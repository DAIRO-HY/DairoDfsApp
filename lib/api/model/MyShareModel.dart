/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class MyShareModel extends JsonSerialize {

  /** id **/
  int id;

  /** 分享的标题（文件名） **/
  String title;

  /** 文件数量 **/
  int fileCount;

  /** 是否分享的仅仅是一个文件夹 **/
  bool folderFlag;

  /** 结束时间 **/
  String endDate;

  /** 创建日期 **/
  String date;

  /** 缩略图 **/
  String thumb;

  MyShareModel({required this.id, required this.title, required this.fileCount, required this.folderFlag, required this.endDate, required this.date, required this.thumb});

  /// 将model转Json
  @override
  toJson() => {
        "id": this.id,
        "title": this.title,
        "fileCount": this.fileCount,
        "folderFlag": this.folderFlag,
        "endDate": this.endDate,
        "date": this.date,
        "thumb": this.thumb,
      };

  /// 将json字符串转MyShareModel对象
  static MyShareModel fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return MyShareModel.fromMap(map);
  }

  /// 将Map对象转MyShareModel对象
  static MyShareModel fromMap(Map<String, dynamic> map) {
    return MyShareModel(
        id: map["id"],
        title: map["title"],
        fileCount: map["fileCount"],
        folderFlag: map["folderFlag"],
        endDate: map["endDate"],
        date: map["date"],
        thumb: map["thumb"]);
  }

  /// 将Json字符串转MyShareModel对象列表
  static List<MyShareModel> fromJsonList(String json) {
    List<dynamic> list = jsonDecode(json);
    return MyShareModel.fromMapList(list);
  }

  /// 将List<Map>对象转MyShareModel对象列表
  static List<MyShareModel> fromMapList(List<dynamic> list) {
    return list.map((map) => MyShareModel.fromMap(map)).toList();
  }
}
