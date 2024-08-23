
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';

class UserInfoModel extends JsonSerialize{

/// 主键
int? id;

/// 用户名
String? name;

/// 管理员标识
bool? adminFlag;
UserInfoModel({required this.adminFlag,required this.id,required this.name});
static UserInfoModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return UserInfoModel.fromMap(map);
}static UserInfoModel fromMap(Map<String, dynamic> map){
    return UserInfoModel(adminFlag: map["adminFlag"],id: map["id"],name: map["name"]);
}static List<UserInfoModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return UserInfoModel.fromMapList(list);
}static List<UserInfoModel> fromMapList(List<dynamic> list){
    return list.map((map) => UserInfoModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "adminFlag" : this.adminFlag,
"id" : this.id,
"name" : this.name,
                };}