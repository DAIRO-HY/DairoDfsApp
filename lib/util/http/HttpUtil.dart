import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

/// 第三方采集系统来源的歌曲下载器
/// 该类用于不支持Range(断点续传)的链接,一次性将文件下载
/// @param url 请求URL
class HttpUtil {
  HttpUtil(this.url);

  ///请求URL
  final String url;

  /// 下载任务
  Client? client;

  /// 连接超时设置（毫秒）
  /// dart的http不支持单独设置连接超时和读取超时，所以这个时间代表总共的时间，也就是连接+读取
  /// 如果想要分别设置连接超时和读取超时，需要使用更底层的HttpClient,但是HttpClient不支持WEB端
  int connectTimeout = 1 * 60 * 60 * 1000;

  /// 读取超时设置（毫秒）
  // int readTimeout = 1*60*60*1000;

  /// 请求方式
  String _method = "GET";

  /// 状态码
  int statusCode = -1;

  /// 返回头部信息
  Map<String, String>? responseHeader;

  /// 读取数据之前回调函数
  Future<bool> Function(int statusCode)? _beforeFunc;

  /// 读取数据回调函数
  // void Function(ByteArray data, int len)? successFunc;
  Future<void> Function(String body)? _successFunc;

  /// 请求完成回调函数
  Future<void> Function(Exception? error)? _finishFunc;

  /// 请求的头部信息
  final _requestHeader = HashMap<String, String>();

  /// 请求参数
  final _param = HashMap<String, String>();

  /// 获取数据长度
  int get contentLength => () {
        final length = this.responseHeader?["content-length"];
        if (length == null) {
          return -1;
        }
        return int.parse(length);
      }();

  /// 设置头部信息
  HttpUtil addHeader(String key, String value) {
    _requestHeader[key] = value;
    return this;
  }

  /// 设置头部信息
  HttpUtil addHeaderAll(Map<String, String> header) {
    _requestHeader.addAll(header);
    return this;
  }

  /// 添加请求数据参数
  HttpUtil addParam(String key, String value) {
    this._param[key] = value;
    return this;
  }

  /// 添加请求数据参数
  HttpUtil addParamAll(Map<String, String> param) {
    this._param.addAll(param);
    return this;
  }

  /// 设置读取数据前的回调函数
  HttpUtil before(Future<bool> Function(int statusCode) block) {
    _beforeFunc = block;
    return this;
  }

  /// 请求成功的回调函数
  HttpUtil success(Future<void> Function(String body) block) {
    this._successFunc = block;
    return this;
  }

  /// 设置最终回调函数
  HttpUtil finish(Future<void> Function(Exception? error) block) {
    this._finishFunc = block;
    return this;
  }

  Future<void> post() async {
    this._method = "POST";
    await this.request();
  }

  Future<void> get() async {
    this._method = "GET";
    await this.request();
  }

  Future<void> head() async {
    this._method = "HEAD";
    await this.request();
  }

  /// 发起请求
  Future<void> request() async {
    final uri = Uri.parse(this.url);
    final client = http.Client();
    this.client = client;
    try {
      Response response;

      try {
        if (this._method == "POST") {
          //POST请求
          response = await client.post(uri, body: this._param, headers: this._requestHeader).timeout(Duration(milliseconds: this.connectTimeout));
        } else if (this._method == "GET") {
          //get请求
          response = await client.get(uri, headers: this._requestHeader).timeout(Duration(milliseconds: this.connectTimeout));
        } else if (this._method == "HEAD") {
          //head请求
          response = await client.head(uri, headers: this._requestHeader).timeout(Duration(milliseconds: this.connectTimeout));
        }else{
          throw Exception("未知请求方式");
        }
      } catch (e) {
        //网络请求失败
        client.close();
        if (this._finishFunc != null) {
          if (e is Exception) {
            await this._finishFunc!(e);
          } else {
            await this._finishFunc!(Exception(e.toString()));
          }
        }
        return;
      }

      //状态码
      this.statusCode = response.statusCode;

      //返回头部信息
      this.responseHeader = response.headers;

      //执行读取数据前的回调
      bool isAllow = true;
      if (this._beforeFunc != null) {
        isAllow = await this._beforeFunc!(this.statusCode);
      }
      if (!isAllow) {
        //throw CancelException();
        return;
      }

      //final body = response.body;
      final body = utf8.decode(response.bodyBytes);
      if (this._successFunc != null) {
        await this._successFunc!(body);
      }
      if (this._finishFunc != null) {
        await this._finishFunc!(null);
      }
    } finally {
      client.close();
    }
  }

  /// 同返回数据中获取头部信息
  String? getResponseHeader(String key) {
    final header = this.responseHeader;
    if (header == null) {
      return null;
    }
    return header[key]?[0];
  }

  /// 取消下载任务
  void cancel() {
    this.client?.close();
  }

/**
 * 请求被取消异常
 */
// class CancelException() : Exception() {
//
// }
}
