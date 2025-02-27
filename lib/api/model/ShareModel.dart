/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class ShareModel extends JsonSerialize {

  /** 名称 **/
  String name;

  /** 大小 **/
  int size;

  /** 是否文件 **/
  bool fileFlag;

  /** 创建日期 **/
  String date;

  /** 缩率图 **/
  String thumb;

  ShareModel({required this.name, required this.size, required this.fileFlag, required this.date, required this.thumb});

  /// 将model转Json
  @override
  toJson() => {
        "name": this.name,
        "size": this.size,
        "fileFlag": this.fileFlag,
        "date": this.date,
        "thumb": this.thumb,
      };

  /// 将json字符串转ShareModel对象
  static ShareModel fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return ShareModel.fromMap(map);
  }

  /// 将Map对象转ShareModel对象
  static ShareModel fromMap(Map<String, dynamic> map) {
    return ShareModel(
        name: map["name"],
        size: map["size"],
        fileFlag: map["fileFlag"],
        date: map["date"],
        thumb: map["thumb"]);
  }

  /// 将Json字符串转ShareModel对象列表
  static List<ShareModel> fromJsonList(String json) {
    List<dynamic> list = jsonDecode(json);
    return ShareModel.fromMapList(list);
  }

  /// 将List<Map>对象转ShareModel对象列表
  static List<ShareModel> fromMapList(List<dynamic> list) {
    return list.map((map) => ShareModel.fromMap(map)).toList();
  }
}
