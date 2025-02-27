/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class UserEditInoutModel extends JsonSerialize {

  /** 主键 **/
  int id;

  /** 用户名 **/
  String name;

  /** 用户电子邮箱 **/
  String email;

  /** 用户状态 **/
  int state;

  /** 创建日期 **/
  String date;

  /** 密码 **/
  String pwd;

  UserEditInoutModel({required this.id, required this.name, required this.email, required this.state, required this.date, required this.pwd});

  /// 将model转Json
  @override
  toJson() => {
        "id": this.id,
        "name": this.name,
        "email": this.email,
        "state": this.state,
        "date": this.date,
        "pwd": this.pwd,
      };

  /// 将json字符串转UserEditInoutModel对象
  static UserEditInoutModel fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return UserEditInoutModel.fromMap(map);
  }

  /// 将Map对象转UserEditInoutModel对象
  static UserEditInoutModel fromMap(Map<String, dynamic> map) {
    return UserEditInoutModel(
        id: map["id"],
        name: map["name"],
        email: map["email"],
        state: map["state"],
        date: map["date"],
        pwd: map["pwd"]);
  }

  /// 将Json字符串转UserEditInoutModel对象列表
  static List<UserEditInoutModel> fromJsonList(String json) {
    List<dynamic> list = jsonDecode(json);
    return UserEditInoutModel.fromMapList(list);
  }

  /// 将List<Map>对象转UserEditInoutModel对象列表
  static List<UserEditInoutModel> fromMapList(List<dynamic> list) {
    return list.map((map) => UserEditInoutModel.fromMap(map)).toList();
  }
}
