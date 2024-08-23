
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';

class UserListModel extends JsonSerialize{

/// 主键
int? id;

/// 用户名
String? name;

/// 用户电子邮箱
String? email;

/// 用户状态
String? state;

/// 创建日期
String? date;
UserListModel({required this.date,required this.email,required this.id,required this.name,required this.state});
static UserListModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return UserListModel.fromMap(map);
}static UserListModel fromMap(Map<String, dynamic> map){
    return UserListModel(date: map["date"],email: map["email"],id: map["id"],name: map["name"],state: map["state"]);
}static List<UserListModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return UserListModel.fromMapList(list);
}static List<UserListModel> fromMapList(List<dynamic> list){
    return list.map((map) => UserListModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "date" : this.date,
"email" : this.email,
"id" : this.id,
"name" : this.name,
"state" : this.state,
                };}