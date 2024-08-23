/*工具自动生成代码,请勿手动修改*/

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

  /// 是否选中
  var isSelected = false;

  TrashBean(TrashModel fileModel) {
    this.id = fileModel.id!;
    this.name = fileModel.name!;
    this.size = fileModel.size!;
    this.fileFlag = fileModel.fileFlag!;
    this.date = fileModel.date!;
  }
}
