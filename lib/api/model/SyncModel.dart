
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';

class SyncModel extends JsonSerialize{
/// 主机域名
String? domain;

/// 同步状态 0：待机中   1：同步中  2：同步错误
String? state;

/// 同步消息
String? msg;
SyncModel({required this.domain,required this.msg,required this.state});
static SyncModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return SyncModel.fromMap(map);
}static SyncModel fromMap(Map<String, dynamic> map){
    return SyncModel(domain: map["domain"],msg: map["msg"],state: map["state"]);
}static List<SyncModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return SyncModel.fromMapList(list);
}static List<SyncModel> fromMapList(List<dynamic> list){
    return list.map((map) => SyncModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "domain" : this.domain,
"msg" : this.msg,
"state" : this.state,
                };}