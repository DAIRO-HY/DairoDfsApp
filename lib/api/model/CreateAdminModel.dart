
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class CreateAdminModel extends JsonSerialize{

/// 用户名
String? name;

/// 登录密码
String? pwd;
CreateAdminModel({required this.name,required this.pwd});
static CreateAdminModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return CreateAdminModel.fromMap(map);
}static CreateAdminModel fromMap(Map<String, dynamic> map){
    return CreateAdminModel(name: map["name"],pwd: map["pwd"]);
}static List<CreateAdminModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return CreateAdminModel.fromMapList(list);
}static List<CreateAdminModel> fromMapList(List<dynamic> list){
    return list.map((map) => CreateAdminModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "name" : this.name,
"pwd" : this.pwd,
                };}