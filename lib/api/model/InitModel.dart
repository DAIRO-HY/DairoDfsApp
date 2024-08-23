
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class InitModel extends JsonSerialize{

/// 用户名
String? name;

/// 登录密码
String? pwd;
InitModel({required this.name,required this.pwd});
static InitModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return InitModel.fromMap(map);
}static InitModel fromMap(Map<String, dynamic> map){
    return InitModel(name: map["name"],pwd: map["pwd"]);
}static List<InitModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return InitModel.fromMapList(list);
}static List<InitModel> fromMapList(List<dynamic> list){
    return list.map((map) => InitModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "name" : this.name,
"pwd" : this.pwd,
                };}