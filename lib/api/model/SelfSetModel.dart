
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class SelfSetModel extends JsonSerialize{


/// 主键
int? id;

/// 用户名
String? name;

/// 用户电子邮箱
String? email;

/// 创建日期
String? date;

/// 用户文件访问路径前缀
String? urlPath;

/// API操作TOKEN
String? apiToken;

/// 端对端加密密钥
String? encryptionKey;
SelfSetModel({required this.apiToken,required this.date,required this.email,required this.encryptionKey,required this.id,required this.name,required this.urlPath});
static SelfSetModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return SelfSetModel.fromMap(map);
}static SelfSetModel fromMap(Map<String, dynamic> map){
    return SelfSetModel(apiToken: map["apiToken"],date: map["date"],email: map["email"],encryptionKey: map["encryptionKey"],id: map["id"],name: map["name"],urlPath: map["urlPath"]);
}static List<SelfSetModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return SelfSetModel.fromMapList(list);
}static List<SelfSetModel> fromMapList(List<dynamic> list){
    return list.map((map) => SelfSetModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "apiToken" : this.apiToken,
"date" : this.date,
"email" : this.email,
"encryptionKey" : this.encryptionKey,
"id" : this.id,
"name" : this.name,
"urlPath" : this.urlPath,
                };}