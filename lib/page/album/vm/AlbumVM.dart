import 'package:dairo_dfs_app/api/model/AlbumModel.dart';

///相册信息Bean
class AlbumVM {

  /// 文件id
  late final int id;

  /// 名称
  late final String name;

  /// 大小
  late final int size;

  /// 创建日期
  late final int date;

  /// 文件缩略图
  late final String thumb;

  /// 是否选中
  var isSelected = false;

  AlbumVM(AlbumModel album) {
    this.id = album.id;
    this.name = album.name;
    this.size = album.size;
    this.date = album.date;
    this.thumb = album.thumb;
  }
}
