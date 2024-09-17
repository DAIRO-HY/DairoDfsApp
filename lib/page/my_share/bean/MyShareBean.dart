/*工具自动生成代码,请勿手动修改*/

import 'package:dairo_dfs_app/api/model/MyShareModel.dart';

///文件信息Bean
class MyShareBean {

  /// 文件id
  late int id;

  /// 名称
  late String name;

  /// 是否多文件
  late bool multipleFlag;

  /// 结束时间
  late String endDate;

  /// 创建日期
  late String date;

  /// 缩略图
  late String? thumb;

  /// 是否选中
  var isSelected = false;

  MyShareBean(MyShareModel model) {
    this.id = model.id!;
    this.name = model.name!;
    this.multipleFlag = model.multipleFlag!;
    this.endDate = model.endDate!;
    this.date = model.date!;
    this.thumb = null;
  }
}
