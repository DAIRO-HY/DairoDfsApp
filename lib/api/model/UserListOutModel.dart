/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class UserListOutModel extends JsonSerialize {

  /** 主键 **/
  int id;

  /** 用户名 **/
  String name;

  /** 用户电子邮箱 **/
  String email;

  /** 用户状态 **/
  String state;

  /** 创建日期 **/
  String date;

  UserListOutModel({required this.id, required this.name, required this.email, required this.state, required this.date});

  /// 将model转Json
  @override
  toJson() => {
        "id": this.id,
        "name": this.name,
        "email": this.email,
        "state": this.state,
        "date": this.date,
      };

  /// 将json字符串转UserListOutModel对象
  static UserListOutModel fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return UserListOutModel.fromMap(map);
  }

  /// 将Map对象转UserListOutModel对象
  static UserListOutModel fromMap(Map<String, dynamic> map) {
    return UserListOutModel(
        id: map["id"],
        name: map["name"],
        email: map["email"],
        state: map["state"],
        date: map["date"]);
  }

  /// 将Json字符串转UserListOutModel对象列表
  static List<UserListOutModel> fromJsonList(String json) {
    List<dynamic> list = jsonDecode(json);
    return UserListOutModel.fromMapList(list);
  }

  /// 将List<Map>对象转UserListOutModel对象列表
  static List<UserListOutModel> fromMapList(List<dynamic> list) {
    return list.map((map) => UserListOutModel.fromMap(map)).toList();
  }
}
