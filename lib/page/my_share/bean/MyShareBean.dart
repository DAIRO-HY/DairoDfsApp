/*工具自动生成代码,请勿手动修改*/

import 'package:dairo_dfs_app/api/model/MyShareModel.dart';

///文件信息Bean
class MyShareBean {

  /// 文件id
  late int id;

  /// 分享的标题（文件名）
  late String name;

  ///文件数量
  late int fileCount;

  ///是否分享的仅仅是一个文件夹
  late bool folderFlag;

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
    this.name = model.title!;
    this.fileCount = model.fileCount!;
    this.folderFlag = model.folderFlag!;
    this.endDate = model.endDate!;
    this.date = model.date!;
    this.thumb = model.thumb;
  }
}
