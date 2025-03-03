/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class AlbumModel extends JsonSerialize {

  /** 文件id **/
  int id;

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

  /** 属性 **/
//Property string `json:"property"`
/** 拍摄时间 **/
  int cameraDate;

  /** 相机名 **/
  String cameraName;

  AlbumModel(
      {      required this.id,
      required this.name,
      required this.size,
      required this.fileFlag,
      required this.date,
      required this.thumb,
      required this.cameraDate,
      required this.cameraName});

  /// 将model转Json
  @override
  toJson() => {
        "id": this.id,
        "name": this.name,
        "size": this.size,
        "fileFlag": this.fileFlag,
        "date": this.date,
        "thumb": this.thumb,
        "cameraDate": this.cameraDate,
        "cameraName": this.cameraName,
      };

  /// 将json字符串转AlbumModel对象
  static AlbumModel fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return AlbumModel.fromMap(map);
  }

  /// 将Map对象转AlbumModel对象
  static AlbumModel fromMap(Map<String, dynamic> map) {
    return AlbumModel(
        id: map["id"],
        name: map["name"],
        size: map["size"],
        fileFlag: map["fileFlag"],
        date: map["date"],
        thumb: map["thumb"],
        cameraDate: map["cameraDate"],
        cameraName: map["cameraName"]);
  }

  /// 将Json字符串转AlbumModel对象列表
  static List<AlbumModel> fromJsonList(String json) {
    List<dynamic> list = jsonDecode(json);
    return AlbumModel.fromMapList(list);
  }

  /// 将List<Map>对象转AlbumModel对象列表
  static List<AlbumModel> fromMapList(List<dynamic> list) {
    return list.map((map) => AlbumModel.fromMap(map)).toList();
  }
}
