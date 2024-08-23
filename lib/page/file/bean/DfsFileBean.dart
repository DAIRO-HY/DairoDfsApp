import 'package:dairo_dfs_app/extension/String++.dart';
import '../../../api/model/FileModel.dart';

///文件信息Bean
class DfsFileBean {
  /// 文件id
  late final int id;

  /// 名称
  late final String name;

  /// 大小
  late final int size;

  /// 缩略图id
  late final int? thumbId;

  /// 是否文件
  late final bool fileFlag;

  /// 创建日期
  late final String date;

  /// 文件路径
  late final String path;

  /// 是否选中
  var isSelected = false;

  DfsFileBean(String parent, FileModel fileModel) {
    this.id = fileModel.id;
    this.name = fileModel.name;
    this.size = fileModel.size;
    this.thumbId = fileModel.thumbId;
    this.fileFlag = fileModel.fileFlag;
    this.date = fileModel.date;
    this.path = "$parent/${fileModel.name}";
  }

  ///得到文件预览url
  String get preview => "/app/files/preview/${this.id}?wait=1";

  ///文件缩略图地址
  String? get thumb => this.thumbId == null ? null : "/app/files/thumb/${this.thumbId}";
}
