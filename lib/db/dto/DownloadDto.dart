import 'package:sqlite3/sqlite3.dart';

class DownloadDto {
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

  /// 下载url
  String url;

  /// 文件大小
  int size;

  /// 已下载大小
  int downloadedSize;

  ///下载状态 0：等待上传  1：上传中   2：暂停中  3:错误  10：上传完成
  int state;

  ///消息
  String? msg;

  ///下载完成之后保存到手机相册, 0:不保存   1:保存到相册
  int saveToImageGallery;

  DownloadDto(
      {this.id = 0,
      this.md5,
      this.thumb,
      required this.name,
      this.size = 0,
      required this.path,
      required this.url,
      this.downloadedSize = 0,
      this.state = 0,
      this.msg,
      this.saveToImageGallery = 0});

  ///将Row转换成Dto
  factory DownloadDto.fromRow(Row row) {
    return DownloadDto(
        id: row["id"],
        md5: row["md5"],
        thumb: row["thumb"],
        name: row["name"],
        size: row["size"],
        path: row["path"],
        url: row["url"],
        downloadedSize: row["downloadedSize"],
        state: row["state"],
        msg: row["msg"],
        saveToImageGallery: row["saveToImageGallery"]);
  }
}
