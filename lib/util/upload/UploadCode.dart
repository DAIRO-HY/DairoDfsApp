///异步上传结果状态值
enum UploadCode {

  ///公开内部消息通信端口
  SENDPORT,

  ///上传完成
  OK,

  ///上传失败
  FAIL,

  ///上传进度
  PROGRESS,

  ///更新消息
  MESSAGE,

  ///md5计算完成
  MD5,
}
