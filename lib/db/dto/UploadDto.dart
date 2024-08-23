import 'package:sqlite3/sqlite3.dart';

class UploadDto {
  /// 下载ID
  int id;

  /// 文件md5
  String? md5;

  /// 缩略图
  String? thumb;

  /// 文件名
  String name;

  /// 文件保存路径
  String path;

  /// 文件大小
  int size;

  /// 服务器端文件夹路径
  String dfsFolder;

  /// 已下载大小
  int uploadedSize;

  ///下载状态 0：等待上传  1：上传中   2：暂停中  3:错误  10：上传完成
  int state;

  ///消息
  String? msg;

  UploadDto(
      {this.id = 0,
      this.md5,
      this.thumb,
      required this.name,
      required this.size,
      required this.path,
      required this.dfsFolder,
      this.uploadedSize = 0,
      this.state = 0,
      this.msg});

  ///将Row转换成Dto
  factory UploadDto.fromRow(Row row) {
    return UploadDto(
        id: row["id"],
        md5: row["md5"],
        thumb: row["thumb"],
        name: row["name"],
        size: row["size"],
        path: row["path"],
        dfsFolder: row["dfsFolder"],
        uploadedSize: row["uploadedSize"],
        state: row["state"],
        msg: row["msg"]);
  }
}
