
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';

class SyncServerModel extends JsonSerialize{

/// 编号
int no;

/// 主机端同步连接
String url;

/// 同步状态 0：待机中   1：同步中  2：同步错误
int state;

/// 同步消息
String msg;

/// 同步日志数
int syncCount;

/// 最后一次同步完成时间
int lastTime;

/// 最后一次心跳时间
int lastHeartTime;
SyncServerModel({required this.lastHeartTime,required this.lastTime,required this.msg,required this.no,required this.state,required this.syncCount,required this.url});
static SyncServerModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return SyncServerModel.fromMap(map);
}static SyncServerModel fromMap(Map<String, dynamic> map){
    return SyncServerModel(lastHeartTime: map["lastHeartTime"],lastTime: map["lastTime"],msg: map["msg"],no: map["no"],state: map["state"],syncCount: map["syncCount"],url: map["url"]);
}static List<SyncServerModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return SyncServerModel.fromMapList(list);
}static List<SyncServerModel> fromMapList(List<dynamic> list){
    return list.map((map) => SyncServerModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "lastHeartTime" : this.lastHeartTime,
"lastTime" : this.lastTime,
"msg" : this.msg,
"no" : this.no,
"state" : this.state,
"syncCount" : this.syncCount,
"url" : this.url,
                };}