/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class MyShareDetailModel extends JsonSerialize {

  /** id **/
  int id;

  /** 链接 **/
  String url;

  /** 加密分享 **/
  String pwd;

  /** 分享的文件夹 **/
  String folder;

  /** 分享的文件夹或文件名,用|分割 **/
  String names;

  /** 结束日期 **/
  String endDate;

  /** 创建日期 **/
  String date;

  MyShareDetailModel(
      {      required this.id,
      required this.url,
      required this.pwd,
      required this.folder,
      required this.names,
      required this.endDate,
      required this.date});

  /// 将model转Json
  @override
  toJson() => {
        "id": this.id,
        "url": this.url,
        "pwd": this.pwd,
        "folder": this.folder,
        "names": this.names,
        "endDate": this.endDate,
        "date": this.date,
      };

  /// 将json字符串转MyShareDetailModel对象
  static MyShareDetailModel fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return MyShareDetailModel.fromMap(map);
  }

  /// 将Map对象转MyShareDetailModel对象
  static MyShareDetailModel fromMap(Map<String, dynamic> map) {
    return MyShareDetailModel(
        id: map["id"],
        url: map["url"],
        pwd: map["pwd"],
        folder: map["folder"],
        names: map["names"],
        endDate: map["endDate"],
        date: map["date"]);
  }

  /// 将Json字符串转MyShareDetailModel对象列表
  static List<MyShareDetailModel> fromJsonList(String json) {
    List<dynamic> list = jsonDecode(json);
    return MyShareDetailModel.fromMapList(list);
  }

  /// 将List<Map>对象转MyShareDetailModel对象列表
  static List<MyShareDetailModel> fromMapList(List<dynamic> list) {
    return list.map((map) => MyShareDetailModel.fromMap(map)).toList();
  }
}
