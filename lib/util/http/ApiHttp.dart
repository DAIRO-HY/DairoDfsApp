import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/util/WaitDialog.dart';
import '../../page/login/LoginPage.dart';
import '../shared_preferences/SettingShared.dart';
import 'HttpUtil.dart';

/// API请求
class ApiHttp<T, B> {
  final T Function(String)? fromJson;
  final String url;

  /**
   * 如果返回值是List类型,该值为list泛型类型
   */
  // private var listType: Class<out Any>? = null

  /// 是否显示加载中的遮罩层
  /// 不显示遮罩层的说明是后台提交，不需要热河提示
  // bool isShowWaiting = true;

  /// 失败时消息回调
  Future<bool> Function(int code, String msg, Object? data)? _failFunc;

  /// 出错时消息回调
  Future<void> Function(String msg)? _errorFunc;

  /// 最终回调
  Future<void> Function()? _finishFunc;

  /// 不允许返回null的回调函数
  Future<void> Function(T)? notNullSuccessFunc;

  /// 允许返回null的回调函数
  Future<void> Function(T?)? nullSuccessFunc;

  /// 没有返回值的成功回调函数
  Future<void> Function()? voidSuccessFunc;

  late final HttpUtil httpUtil;

  ///记录当前泛型类型
  final Type type;

  ///当前上下文
  BuildContext? context;

  ApiHttp(this.url, [this.fromJson]) : type = T {
    this.httpUtil = HttpUtil(SettingShared.domainNotNull + this.url);

    //超时设置
    this.httpUtil.connectTimeout = 15000;

    // 设置请求的Content-Type为application/x-www-form-urlencoded
    this.httpUtil.addHeader("Content-Type", "application/x-www-form-urlencoded");

    // val packageManager = ThisApplication.app.packageManager
    // val info = packageManager.getPackageInfo(ThisApplication.app.packageName, 0)

    //客户端版本标识
    final int clientFlag;
    if (Platform.isAndroid) {
      clientFlag = 1;
    } else if (Platform.isIOS) {
      clientFlag = 2;
    } else if (Platform.isMacOS) {
      clientFlag = 4;
    } else if (Platform.isWindows) {
      clientFlag = 3;
    } else if (Platform.isLinux) {
      clientFlag = 5;
    } else if (Platform.isFuchsia) {
      clientFlag = 7;
    } else {
      clientFlag = 0;
    }

    //添加公共参数
    this.httpUtil.addParam("_clientFlag", clientFlag.toString());
    // this.httpUtil.addParam("model", Build.MODEL)
    // this.httpUtil.addParam("_osName", Build.VERSION.RELEASE)
    // this.httpUtil.addParam("_osCode", Build.VERSION.SDK_INT)
    // this.httpUtil.addParam("_versionName", info.versionName)
    this.httpUtil.addParam("_version", "1");
    // if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
    //     this.httpUtil.addParam("_versionCode", info.longVersionCode)
    // } else {
    //     this.httpUtil.addParam("_versionCode", info.versionCode)
    // }

    final token = SettingShared.token;
    if (token != null) {
      //添加登录状态
      this.httpUtil.addParam("_token", token);
    }
  }

  /// 添加参数
  B add(String key, Object? value) {
    if (value == null) {
      return this as B;
    }
    if (value is String) {
      if (value.isEmpty) {
        //如果是空字符串,忽律掉该是¥参数
        return this as B;
      }
    }
    if (value is List) {
      final listValue = value.join(",");
      this.httpUtil.addParam(key, listValue);
    } else {
      this.httpUtil.addParam(key, value.toString());
    }
    return this as B;
  }

  /// 请求失败时的回调
  B fail(Future<bool> Function(int code, String msg, Object? data) block) {
    this._failFunc = block;
    return this as B;
  }

  /// 请求异常时的回调
  B error(Future<void> Function(String msg) block) {
    this._errorFunc = block;
    return this as B;
  }

  /// 最终回调
  B finish(Future<void> Function() block) {
    this._finishFunc = block;
    return this as B;
  }

  /// 调用失败函数
  Future<void> _callFail(int code, String msg, Object? data) async {
    if (this._failFunc != null) {
      final isBreak = await this._failFunc!(code, msg, data);
      if (isBreak) {
        return;
      }
    }
    //有遮照层
    this.context?.toast(msg);
  }

  /// 调用出错函数
  Future<void> callError(String msg) async {
    if (this._errorFunc != null) {
      await this._errorFunc!(msg);
    } else {
      //有遮照层
      this.context?.toast(msg);
    }
  }

  /// 调用成功函数
  Future<void> callSuccess(String body) async {
    final statusCode = this.httpUtil.statusCode;
    if (statusCode != 200) {
      try {
        Map<String, dynamic> map = jsonDecode(body);
        final int code = map["code"];
        final String msg = map["msg"];
        final Object? data = map["data"];
        if (code == 5) {
          //登录失效
          SettingShared.logout();
          this.context?.toast(msg);
          this.context?.relaunch(LoginPage());
        } else {
          await this._callFail(code, msg, data);
        }
      } catch (e) {
        await this.callError("服务器异常,状态码:${statusCode} 错误信息:${e}");
      }
      return;
    }
    if (this.voidSuccessFunc != null) {
      //不需要返回值的成功函数
      await this.voidSuccessFunc!();
    } else {
      T? model;
      if (this.fromJson != null) {
        //将JSON转换成对象
        if (body.isEmpty) {
          model = null;
        } else {
          model = this.fromJson!(body);
        }
      } else {
        //返回值是哟i个基本数据类型
        model = this.toT(body);
      }
      if (this.nullSuccessFunc != null) {
        //允许返回值为NULL的成功回调函数
        await this.nullSuccessFunc!(model);
      } else if (notNullSuccessFunc != null) {
        await this.notNullSuccessFunc!(model as T);
      } else {
        ;
      }
    }
  }

  /// 调用最终执行函数
  Future<void> callFinish(Exception? error) async {
    if (error != null) {
      if (error is SocketException || error is TimeoutException) {
        await this.callError("网络连接失败");
      } else {
        await this.callError(error.toString());
      }
    }
    if (this._finishFunc != null) {
      //最终执行
      await this._finishFunc!();
    }
  }

  /// 发起请求
  Future<void> request(BuildContext? context) async {
    this.context = context;
    WaitDialog.show(context);
    await this.httpUtil.success((body) async {
      WaitDialog.hide(context);
      await this.callSuccess(body);
    }).finish((e) async {
      if (e != null) {
        WaitDialog.hide(context);
      }
      await this.callFinish(e);
    }).post();
  }

  ///转换成正确的泛型类型
  T? toT(String body) {
    if (this.type == String) {
      return body as T;
    }
    if (body.isEmpty) {
      return null;
    }
    if (this.type == int) {
      return int.parse(body) as T;
    }
    return null;
  }

  /// 取消请求
  void cancel() {
    this.httpUtil.cancel();
  }
}

class StringExt {
  ///将json字符串数组转List<String>
  static List<String> fromJsonList(String json) {
    List<dynamic> jsonList = jsonDecode(json);
    return List<String>.from(jsonList);
  }
}
