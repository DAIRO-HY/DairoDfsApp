/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class TrashModel extends JsonSerialize {

  /** 文件id **/
  int id;

  /** 名称 **/
  String name;

  /** 大小 **/
  int size;

  /** 是否文件 **/
  bool fileFlag;

  /** 删除日期 **/
  String date;

  /** 缩率图 **/
  String thumb;

  TrashModel(
      {      required this.id,
      required this.name,
      required this.size,
      required this.fileFlag,
      required this.date,
      required this.thumb});

  /// 将model转Json
  @override
  toJson() => {
        "id": this.id,
        "name": this.name,
        "size": this.size,
        "fileFlag": this.fileFlag,
        "date": this.date,
        "thumb": this.thumb,
      };

  /// 将json字符串转TrashModel对象
  static TrashModel fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return TrashModel.fromMap(map);
  }

  /// 将Map对象转TrashModel对象
  static TrashModel fromMap(Map<String, dynamic> map) {
    return TrashModel(
        id: map["id"],
        name: map["name"],
        size: map["size"],
        fileFlag: map["fileFlag"],
        date: map["date"],
        thumb: map["thumb"]);
  }

  /// 将Json字符串转TrashModel对象列表
  static List<TrashModel> fromJsonList(String json) {
    List<dynamic> list = jsonDecode(json);
    return TrashModel.fromMapList(list);
  }

  /// 将List<Map>对象转TrashModel对象列表
  static List<TrashModel> fromMapList(List<dynamic> list) {
    return list.map((map) => TrashModel.fromMap(map)).toList();
  }
}
