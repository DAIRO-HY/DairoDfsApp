/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class ModifyPwdAppModel extends JsonSerialize {

  /** 旧密码 **/
  String oldPwd;

  /** 新密码 **/
  String pwd;

  ModifyPwdAppModel(
      {      required this.oldPwd,
      required this.pwd});

  /// 将model转Json
  @override
  toJson() => {
        "oldPwd": this.oldPwd,
        "pwd": this.pwd,
      };

  /// 将json字符串转ModifyPwdAppModel对象
  static ModifyPwdAppModel fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return ModifyPwdAppModel.fromMap(map);
  }

  /// 将Map对象转ModifyPwdAppModel对象
  static ModifyPwdAppModel fromMap(Map<String, dynamic> map) {
    return ModifyPwdAppModel(
        oldPwd: map["oldPwd"],
        pwd: map["pwd"]);
  }

  /// 将Json字符串转ModifyPwdAppModel对象列表
  static List<ModifyPwdAppModel> fromJsonList(String json) {
    List<dynamic> list = jsonDecode(json);
    return ModifyPwdAppModel.fromMapList(list);
  }

  /// 将List<Map>对象转ModifyPwdAppModel对象列表
  static List<ModifyPwdAppModel> fromMapList(List<dynamic> list) {
    return list.map((map) => ModifyPwdAppModel.fromMap(map)).toList();
  }
}
