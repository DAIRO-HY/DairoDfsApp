import 'dart:isolate';

import 'package:dairo_dfs_app/util/shared_preferences/SettingShared.dart';
import 'package:dairo_dfs_app/util/upload/UploadCode.dart';
import 'package:dairo_dfs_app/util/upload/UploadMessage.dart';

import 'UploadThread.dart';

///文件上传任务
class UploadManager {
  ///下载中的文件信息
  final UploadingInfo info;

  ///下载完成回调函数
  final void Function() onSuccess;

  ///下载完成回调函数
  final void Function(String error) onError;

  ///下载状态消息回调函数
  final void Function(String error) onStateMsgChange;

  ///下载md5计算完成回调函数
  final void Function(String error) onMd5Compute;

  ///下载完成回调函数
  final void Function(int size, int downloadedSize, int speed, int remainder) onProgress;

  ///文件上传线程
  late Isolate _isolate;

  /// 这是一个往上传线程发送消息的端口
  SendPort? _toThreadSendPort;

  /// 创建一个 ReceivePort
  final _receivePort = ReceivePort();

  UploadManager(
      {required this.info,
      required this.onSuccess,
      required this.onError,
      required this.onProgress,
      required this.onStateMsgChange,
      required this.onMd5Compute}) {
    this._receivePort.listen(_receive);
  }

  ///接收到消息时的回调
  void _receive(Object? message) {
    message as UploadMessage;
    switch (message.code) {
      case UploadCode.SENDPORT: //公开内部消息通信端口
        this._toThreadSendPort = message.data as SendPort;
      case UploadCode.OK: //上传完成
        this._receivePort.close(); //停止接收消息
        this._isolate.kill(priority: Isolate.immediate);
        this.onSuccess();
      case UploadCode.FAIL: //上传出错
        final msg = message.data as String;
        this._receivePort.close(); //停止接收消息
        this._isolate.kill(priority: Isolate.immediate);
        this.onError(msg);
      case UploadCode.PROGRESS: //上传进度
        final data = message.data as List<Object>;
        int size = data[0] as int;
        int uploadedSize = data[1] as int;
        int speed = data[2] as int;
        int needTime = data[3] as int;

        //更新进度
        this.onProgress(size, uploadedSize, speed, needTime);
      case UploadCode.MESSAGE: //更新消息
        final msg = message.data as String;
        this.onStateMsgChange(msg);
      case UploadCode.MD5: //文件计算md5完成
        final md5 = message.data as String;
        this.onMd5Compute(md5);
    }
  }

  ///开始上传
  upload() {
    Isolate.spawn((List<dynamic> args) async {
      //消息通信端口
      final sendPort = args[0] as SendPort;

      //正在上传的文件信息
      final info = args[1] as UploadingInfo;

      //服务器主机
      final domain = args[2] as String;

      //开始上传线程
      final block = UploadIsolateBlock(sendPort, info, domain);
      await block.upload();
    }, [this._receivePort.sendPort, this.info, SettingShared.domainNotNull]).then((instance) {
      this._isolate = instance;
    });
  }

  ///停止正在下载任务
  void pause() {
    this._toThreadSendPort?.send("PAUSE");
  }
}

///正在上传的文件信息
class UploadingInfo {
  /// 文件md5
  String? md5;

  /// 文件大小
  final int size;

  /// 文件路径
  final String path;

  /// 服务器端文件夹路径
  final String dfsPath;

  /// 会员登录票据
  final String token;

  UploadingInfo({required this.md5, required this.size, required this.path, required this.dfsPath, required this.token});
}
