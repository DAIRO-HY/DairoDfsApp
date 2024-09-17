/*工具自动生成代码,请勿手动修改*/

import 'package:dairo_dfs_app/extension/Number++.dart';

import '../../../api/model/TrashModel.dart';

///文件信息Bean
class TrashBean {

  /// 文件id
  late int id;

  /// 名称
  late String name;

  /// 大小
  late String size;

  /// 是否文件
  late bool fileFlag;

  /// 删除日期
  late String date;

  /// 缩略图
  late String? thumb;

  /// 是否选中
  var isSelected = false;

  TrashBean(TrashModel model) {
    this.id = model.id!;
    this.name = model.name!;
    this.size = model.size.dataSize;
    this.fileFlag = model.fileFlag!;
    this.date = model.date!;
    this.thumb = model.thumb;
  }
}
