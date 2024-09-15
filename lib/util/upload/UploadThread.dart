import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:dairo_dfs_app/extension/File++.dart';
import 'package:dairo_dfs_app/util/upload/UploadCode.dart';
import '../../api/API.dart';
import 'UploadManager.dart';
import 'UploadMessage.dart';

///文件上传任务
class UploadIsolateBlock {
  ///消息通信端口
  final SendPort sendPort;

  ///文件信息
  final UploadingInfo info;

  ///服务器域名
  final String domain;

  ///接收消息端口
  final receivePort = ReceivePort();

  ///正在请求的客户端
  HttpClient? _client;

  ///是否被强制中断
  bool isBreak = false;

  UploadIsolateBlock(this.sendPort, this.info, this.domain) {
    //设置接收消息的函数
    this.receivePort.listen(this._receive);

    //向外部公开端口
    this.sendPort.send(UploadMessage(UploadCode.SENDPORT, this.receivePort.sendPort));
  }

  ///接收到消息时的回调
  Future<void> _receive(Object? msg) async {
    if (msg == "PAUSE") {
      //强行停止
      this.isBreak = true;
      this._client?.close(force: true);

      //被强行停止
      this.sendPort.send(UploadMessage(UploadCode.FAIL, "PAUSE"));
    }
  }

  ///开始上传任务
  Future<void> upload() async {
    try {
      await this._start();

      //上传完成
      this.sendPort.send(UploadMessage(UploadCode.OK));
    } catch (e) {
      if (this.isBreak) {
        //被强行停止
        this.sendPort.send(UploadMessage(UploadCode.FAIL, "PAUSE"));
        return;
      }

      //上传出错
      final String error;
      if (e is SocketException) {
        error = "网络连接失败";
      } else if (e is HttpException) {
        error = "网络连接中断";
      } else {
        final message = e.toString().substring(11);
        if (message.startsWith("{")) {
          //这是一个json格式的数据
          Map<String, dynamic> map = jsonDecode(message);
          final String? msg = map["msg"];
          error = msg ?? message;
        } else {
          error = message;
        }
      }
      final message = UploadMessage(UploadCode.FAIL, error);
      this.sendPort.send(message);
    } finally {
      this.receivePort.close();
    }
  }

  ///开始上传
  Future<void> _start() async {
    //当前上传文件
    final file = File(this.info.path);
    if (!file.existsSync()) {
      //文件不存在
      throw Exception("文件不存在");
    }

    final size = file.lengthSync();
    if (size != this.info.size) {
      //简单验证一下文件大小，防止文件添加上传之后，源文件又被替换，导致上传的文件不完整
      throw Exception("文件被修改，请重新添加上传");
    }

    //得到文件的MD5值
    if (this.info.md5 == null) {
      //文件校验中消息
      final message = UploadMessage(UploadCode.MESSAGE, "文件校验中");
      this.sendPort.send(message);
      this.info.md5 = await file.md5;

      //发送md5计算完成
      final md5Message = UploadMessage(UploadCode.MD5, this.info.md5);
      this.sendPort.send(md5Message);
    }

    //设置消息为正在上传
    final connctionMessage = UploadMessage(UploadCode.MESSAGE, "网络连接中");
    this.sendPort.send(connctionMessage);

    //尝试通过md5上传
    final isSuccess = await this._uploadByMd5();
    if (isSuccess) {
      //文件上传成功
      return;
    }

    //获取到已经上传的大小
    var uploadedSize = await this._getUploadedSize();
    if (uploadedSize == this.info.size) {
      //理论上,这段代码不会被执行
      //文件已经上传完成,无需再上传
      return;
    }

    //以流的形式上传文件
    await this._uploadFile(file, uploadedSize);

    //再次通过md5上传
    if (await this._uploadByMd5()) {
      //文件上传成功
      return;
    }
    throw Exception("服务端校验文件失败，请重新上传。");
  }

  ///获取文件已经上传大小
  Future<int> _getUploadedSize([int times = 0]) async {
    final uri = Uri.parse("${this.domain}${Api.FILE_UPLOAD_GET_UPLOADED_SIZE}?md5=${this.info.md5}&_token=${this.info.token}");
    final client = HttpClient();
    this._client = client;
    try {
      final request = await client.openUrl("POST", uri);
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode == 200) {
        return int.parse(body);
      }

      //这是一个json格式的数据
      Map<String, dynamic> map = jsonDecode(body);
      if (map["code"] == 1005 && times < 3) {
        //重试3次
        await Future.delayed(Duration(seconds: 1));
        return this._getUploadedSize(times + 1);
      }
      throw Exception(body);
    } finally {
      client.close();
    }
  }

  ///以流的形式上传文件
  Future<void> _uploadFile(File file, int uploadedSize) async {
    //文件输入流
    final raf = file.openSync();

    final uri = Uri.parse("${this.domain}/app/file_upload/by_stream/${this.info.md5}?_token=${this.info.token}");
    final client = HttpClient();
    this._client = client;
    try {
      final request = await client.openUrl("POST", uri);
      //request.headers.set(HttpHeaders.contentTypeHeader, "application/octet-stream");

      //跳过已经上传的部分数据
      raf.setPositionSync(uploadedSize);

      //当前时间戳
      var lastTime = DateTime.now().millisecondsSinceEpoch;

      //最后一次记录的上传大小（用来计算网速）
      var lastUploadSize = uploadedSize;
      while (true) {
        final data = raf.readSync(64 * 1024);
        if (data.isEmpty) {
          break;
        }
        request.add(data);

        //实时发送数据，如果没有这段代码，默认会在调用request.close()才开始发送数据
        await request.flush();
        uploadedSize += data.length;

        final curTime = DateTime.now().millisecondsSinceEpoch;
        if (curTime - lastTime > 1000) {
          //计算上传速度(Byte)
          final speed = (uploadedSize - lastUploadSize) / (curTime - lastTime) * 1000;

          //剩余时间(毫秒)
          final needTime = (this.info.size - uploadedSize) / speed * 1000;

          //发送上传进度消息
          final message = UploadMessage(UploadCode.PROGRESS, [this.info.size, uploadedSize, speed.toInt(), needTime.toInt()]);

          this.sendPort.send(message);
          lastUploadSize = uploadedSize;
          lastTime = DateTime.now().millisecondsSinceEpoch;
          // print("-->$uploadedSize");
        }
        if (this.isBreak) {
          //上传被强行停止了
          throw Exception();
        }
      }

      //如果上传的过程中连接被中断，这里有可能报错
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode != 200) {
        //上传报错了
        throw Exception(body);
      }
    } finally {
      raf.closeSync();
      client.close();
    }
  }

  ///通过md5上传,实际不上传文件,服务器端会验证md5的文件是否已经存在
  Future<bool> _uploadByMd5() async {
    final uri = Uri.parse(this.domain + Api.FILE_UPLOAD_BY_MD5 + "?_token=${this.info.token}");
    final client = HttpClient();
    this._client = client;
    try {
      final request = await client.openUrl("POST", uri);
      request.headers.set(HttpHeaders.contentTypeHeader, "application/x-www-form-urlencoded");

      // 添加请求体参数
      final payload = {"md5": this.info.md5!, "path": this.info.dfsPath, "token": this.info.token};
      final encodedParameters = payload.entries.map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}').join('&');
      request.write(encodedParameters);
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode == 200) {
        return true;
      }
      Map<String, dynamic> map = jsonDecode(body);
      final code = map["code"];
      if (code == 1004) {
        //该文件服务端不存在
        return false;
      }
      throw Exception(body);
    } finally {
      client.close();
    }
  }
}
