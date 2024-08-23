
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class ProfileModel extends JsonSerialize{

/// 文件上传限制
String? uploadMaxSize;

/// 存储目录
String? folders;

/// 同步域名
String? syncDomains;
ProfileModel({required this.folders,required this.syncDomains,required this.uploadMaxSize});
static ProfileModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return ProfileModel.fromMap(map);
}static ProfileModel fromMap(Map<String, dynamic> map){
    return ProfileModel(folders: map["folders"],syncDomains: map["syncDomains"],uploadMaxSize: map["uploadMaxSize"]);
}static List<ProfileModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return ProfileModel.fromMapList(list);
}static List<ProfileModel> fromMapList(List<dynamic> list){
    return list.map((map) => ProfileModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "folders" : this.folders,
"syncDomains" : this.syncDomains,
"uploadMaxSize" : this.uploadMaxSize,
                };}