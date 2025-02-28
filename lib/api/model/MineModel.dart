/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class MineModel extends JsonSerialize {

  /** 主键 **/
  int id;

  /** 用户名 **/
  String name;

  /** 用户电子邮箱 **/
  String email;

  /** 创建日期 **/
  String date;

  /** 用户文件访问路径前缀 **/
  String urlPath;

  /** API操作TOKEN **/
  String apiToken;

  /** 端对端加密密钥 **/
  String encryptionKey;

  MineModel(
      {      required this.id,
      required this.name,
      required this.email,
      required this.date,
      required this.urlPath,
      required this.apiToken,
      required this.encryptionKey});

  /// 将model转Json
  @override
  toJson() => {
        "id": this.id,
        "name": this.name,
        "email": this.email,
        "date": this.date,
        "urlPath": this.urlPath,
        "apiToken": this.apiToken,
        "encryptionKey": this.encryptionKey,
      };

  /// 将json字符串转MineModel对象
  static MineModel fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return MineModel.fromMap(map);
  }

  /// 将Map对象转MineModel对象
  static MineModel fromMap(Map<String, dynamic> map) {
    return MineModel(
        id: map["id"],
        name: map["name"],
        email: map["email"],
        date: map["date"],
        urlPath: map["urlPath"],
        apiToken: map["apiToken"],
        encryptionKey: map["encryptionKey"]);
  }

  /// 将Json字符串转MineModel对象列表
  static List<MineModel> fromJsonList(String json) {
    List<dynamic> list = jsonDecode(json);
    return MineModel.fromMapList(list);
  }

  /// 将List<Map>对象转MineModel对象列表
  static List<MineModel> fromMapList(List<dynamic> list) {
    return list.map((map) => MineModel.fromMap(map)).toList();
  }
}
