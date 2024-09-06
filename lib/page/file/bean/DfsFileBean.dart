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
    this.fileFlag = fileModel.fileFlag;
    this.date = fileModel.date;
    this.path = "$parent/${fileModel.name}";
  }

  ///得到文件预览url
  String get preview => "/app/files/preview/${this.id}";

  ///文件缩略图地址
  String? get thumb {
    final lowerName = this.name.toLowerCase();
    if (lowerName.endsWith(".jpg") ||
        lowerName.endsWith(".jpeg") ||
        lowerName.endsWith(".png") ||
        lowerName.endsWith(".bmp") ||
        lowerName.endsWith(".gif") ||
        lowerName.endsWith(".ico") ||
        lowerName.endsWith(".svg") ||
        lowerName.endsWith(".tiff") ||
        lowerName.endsWith(".webp") ||
        lowerName.endsWith(".wmf") ||
        lowerName.endsWith(".wmz") ||
        lowerName.endsWith(".jp2") ||
        lowerName.endsWith(".eps") ||
        lowerName.endsWith(".tga") ||
        lowerName.endsWith(".jfif") ||
        lowerName.endsWith(".psd") ||
        lowerName.endsWith(".psb") ||
        lowerName.endsWith(".ai") ||
        lowerName.endsWith(".mp4") ||
        lowerName.endsWith(".mov") ||
        lowerName.endsWith(".avi") ||
        lowerName.endsWith(".mkv") ||
        lowerName.endsWith(".flv") ||
        lowerName.endsWith(".rm") ||
        lowerName.endsWith(".rmvb") ||
        lowerName.endsWith(".3gp") ||
        lowerName.endsWith(".cr3") ||
        lowerName.endsWith(".cr2")) {
      return "/app/files/thumb/${this.id}";
    } else {
      return null;
    }
  }
}
