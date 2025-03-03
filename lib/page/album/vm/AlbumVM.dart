import 'package:dairo_dfs_app/api/model/AlbumModel.dart';

///相册信息Bean
class AlbumVM {

  /// 文件id
  late final int id;

  /// 名称
  late final String name;

  /// 大小
  late final int size;

  /// 是否文件
  late final bool fileFlag;

  /// 创建日期
  late final String date;

  /// 文件路径
  // late final String path;

  /// 文件缩略图
  late final String? thumb;

  /// 是否选中
  var isSelected = false;

  AlbumVM(AlbumModel album) {
    this.id = album.id;
    this.name = album.name;
    this.size = album.size;
    this.fileFlag = album.fileFlag;
    this.date = album.date;
    // this.path = "$parent/${album.name}";
    this.thumb = album.thumb;
  }

  ///得到文件预览url
  String get preview => "/app/files/preview/${this.id}/${this.name}";
}
