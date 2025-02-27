/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class FilePropertyHistoryModel extends JsonSerialize {

  /** 文件ID **/
  int id;

  /** 大小 **/
  String size;

  /** 创建日期 **/
  String date;

  FilePropertyHistoryModel({required this.id, required this.size, required this.date});

  /// 将model转Json
  @override
  toJson() => {
        "id": this.id,
        "size": this.size,
        "date": this.date,
      };

  /// 将json字符串转FilePropertyHistoryModel对象
  static FilePropertyHistoryModel fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return FilePropertyHistoryModel.fromMap(map);
  }

  /// 将Map对象转FilePropertyHistoryModel对象
  static FilePropertyHistoryModel fromMap(Map<String, dynamic> map) {
    return FilePropertyHistoryModel(
        id: map["id"],
        size: map["size"],
        date: map["date"]);
  }

  /// 将Json字符串转FilePropertyHistoryModel对象列表
  static List<FilePropertyHistoryModel> fromJsonList(String json) {
    List<dynamic> list = jsonDecode(json);
    return FilePropertyHistoryModel.fromMapList(list);
  }

  /// 将List<Map>对象转FilePropertyHistoryModel对象列表
  static List<FilePropertyHistoryModel> fromMapList(List<dynamic> list) {
    return list.map((map) => FilePropertyHistoryModel.fromMap(map)).toList();
  }
}
