/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class LoginAppOutModel extends JsonSerialize {

  /** 用户名 **/
  String token;

  /** 是否管理员 **/
  bool isAdmin;

  LoginAppOutModel(
      {      required this.token,
      required this.isAdmin});

  /// 将model转Json
  @override
  toJson() => {
        "token": this.token,
        "isAdmin": this.isAdmin,
      };

  /// 将json字符串转LoginAppOutModel对象
  static LoginAppOutModel fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return LoginAppOutModel.fromMap(map);
  }

  /// 将Map对象转LoginAppOutModel对象
  static LoginAppOutModel fromMap(Map<String, dynamic> map) {
    return LoginAppOutModel(
        token: map["token"],
        isAdmin: map["isAdmin"]);
  }

  /// 将Json字符串转LoginAppOutModel对象列表
  static List<LoginAppOutModel> fromJsonList(String json) {
    List<dynamic> list = jsonDecode(json);
    return LoginAppOutModel.fromMapList(list);
  }

  /// 将List<Map>对象转LoginAppOutModel对象列表
  static List<LoginAppOutModel> fromMapList(List<dynamic> list) {
    return list.map((map) => LoginAppOutModel.fromMap(map)).toList();
  }
}
