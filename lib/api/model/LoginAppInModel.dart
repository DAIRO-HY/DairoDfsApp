/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class LoginAppInModel extends JsonSerialize {

  /** 用户名 **/
  String name;

  /** 登录密码(MD5) **/
  String pwd;

  /** 设备唯一标识 **/
  String deviceId;

  LoginAppInModel({required this.name, required this.pwd, required this.deviceId});

  /// 将model转Json
  @override
  toJson() => {
        "name": this.name,
        "pwd": this.pwd,
        "deviceId": this.deviceId,
      };

  /// 将json字符串转LoginAppInModel对象
  static LoginAppInModel fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return LoginAppInModel.fromMap(map);
  }

  /// 将Map对象转LoginAppInModel对象
  static LoginAppInModel fromMap(Map<String, dynamic> map) {
    return LoginAppInModel(
        name: map["name"],
        pwd: map["pwd"],
        deviceId: map["deviceId"]);
  }

  /// 将Json字符串转LoginAppInModel对象列表
  static List<LoginAppInModel> fromJsonList(String json) {
    List<dynamic> list = jsonDecode(json);
    return LoginAppInModel.fromMapList(list);
  }

  /// 将List<Map>对象转LoginAppInModel对象列表
  static List<LoginAppInModel> fromMapList(List<dynamic> list) {
    return list.map((map) => LoginAppInModel.fromMap(map)).toList();
  }
}
