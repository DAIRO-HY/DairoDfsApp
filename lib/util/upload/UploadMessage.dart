import 'UploadCode.dart';

///上传消息
class UploadMessage {

  /// 状态值
  final UploadCode code;

  /// 消息数据
  final Object? data;
  UploadMessage(this.code,[this.data]);
}
