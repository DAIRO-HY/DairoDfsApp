
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class ModifyPwdAppModel extends JsonSerialize{

String? oldPwd;

String? pwd;
ModifyPwdAppModel({required this.oldPwd,required this.pwd});
static ModifyPwdAppModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return ModifyPwdAppModel.fromMap(map);
}static ModifyPwdAppModel fromMap(Map<String, dynamic> map){
    return ModifyPwdAppModel(oldPwd: map["oldPwd"],pwd: map["pwd"]);
}static List<ModifyPwdAppModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return ModifyPwdAppModel.fromMapList(list);
}static List<ModifyPwdAppModel> fromMapList(List<dynamic> list){
    return list.map((map) => ModifyPwdAppModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "oldPwd" : this.oldPwd,
"pwd" : this.pwd,
                };}