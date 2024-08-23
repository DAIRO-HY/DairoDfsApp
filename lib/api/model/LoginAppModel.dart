
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class LoginAppModel extends JsonSerialize{

String? name;

String? pwd;

String? deviceId;
LoginAppModel({required this.deviceId,required this.name,required this.pwd});
static LoginAppModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return LoginAppModel.fromMap(map);
}static LoginAppModel fromMap(Map<String, dynamic> map){
    return LoginAppModel(deviceId: map["deviceId"],name: map["name"],pwd: map["pwd"]);
}static List<LoginAppModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return LoginAppModel.fromMapList(list);
}static List<LoginAppModel> fromMapList(List<dynamic> list){
    return list.map((map) => LoginAppModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "deviceId" : this.deviceId,
"name" : this.name,
"pwd" : this.pwd,
                };}