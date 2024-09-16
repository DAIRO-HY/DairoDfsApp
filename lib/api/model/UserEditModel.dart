
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class UserEditModel extends JsonSerialize{

/// 主键
int? id;

/// 用户名
String? name;

       

/// 用户电子邮箱
String? email;

/// 用户状态
int state;

/// 创建日期
String? date;

/// 密码
String? pwd;

       
UserEditModel({required this.date,required this.email,required this.id,required this.name,required this.pwd,required this.state});
static UserEditModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return UserEditModel.fromMap(map);
}static UserEditModel fromMap(Map<String, dynamic> map){
    return UserEditModel(date: map["date"],email: map["email"],id: map["id"],name: map["name"],pwd: map["pwd"],state: map["state"]);
}static List<UserEditModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return UserEditModel.fromMapList(list);
}static List<UserEditModel> fromMapList(List<dynamic> list){
    return list.map((map) => UserEditModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "date" : this.date,
"email" : this.email,
"id" : this.id,
"name" : this.name,
"pwd" : this.pwd,
"state" : this.state,
                };}