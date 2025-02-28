/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class FolderModel extends JsonSerialize {

  /** 名称 **/
  String name;

  /** 大小 **/
  String size;

  /** 是否文件 **/
  bool fileFlag;

  /** 创建日期 **/
  String date;

  FolderModel(
      {      required this.name,
      required this.size,
      required this.fileFlag,
      required this.date});

  /// 将model转Json
  @override
  toJson() => {
        "name": this.name,
        "size": this.size,
        "fileFlag": this.fileFlag,
        "date": this.date,
      };

  /// 将json字符串转FolderModel对象
  static FolderModel fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return FolderModel.fromMap(map);
  }

  /// 将Map对象转FolderModel对象
  static FolderModel fromMap(Map<String, dynamic> map) {
    return FolderModel(
        name: map["name"],
        size: map["size"],
        fileFlag: map["fileFlag"],
        date: map["date"]);
  }

  /// 将Json字符串转FolderModel对象列表
  static List<FolderModel> fromJsonList(String json) {
    List<dynamic> list = jsonDecode(json);
    return FolderModel.fromMapList(list);
  }

  /// 将List<Map>对象转FolderModel对象列表
  static List<FolderModel> fromMapList(List<dynamic> list) {
    return list.map((map) => FolderModel.fromMap(map)).toList();
  }
}
