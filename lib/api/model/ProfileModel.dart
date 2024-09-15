
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class ProfileModel extends JsonSerialize{

/// 记录同步日志
bool? openSqlLog;

/// 将当前服务器设置为只读,仅作为备份使用
bool? hasReadOnly;

/// 文件上传限制
String? uploadMaxSize;

/// 存储目录
String? folders;

/// 同步域名
String? syncDomains;

/// 分机与主机同步连接票据
String? token;
ProfileModel({required this.folders,required this.hasReadOnly,required this.openSqlLog,required this.syncDomains,required this.token,required this.uploadMaxSize});
static ProfileModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return ProfileModel.fromMap(map);
}static ProfileModel fromMap(Map<String, dynamic> map){
    return ProfileModel(folders: map["folders"],hasReadOnly: map["hasReadOnly"],openSqlLog: map["openSqlLog"],syncDomains: map["syncDomains"],token: map["token"],uploadMaxSize: map["uploadMaxSize"]);
}static List<ProfileModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return ProfileModel.fromMapList(list);
}static List<ProfileModel> fromMapList(List<dynamic> list){
    return list.map((map) => ProfileModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "folders" : this.folders,
"hasReadOnly" : this.hasReadOnly,
"openSqlLog" : this.openSqlLog,
"syncDomains" : this.syncDomains,
"token" : this.token,
"uploadMaxSize" : this.uploadMaxSize,
                };}