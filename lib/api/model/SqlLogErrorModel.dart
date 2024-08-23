
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


/// sql数据库日志
class SqlLogErrorModel extends JsonSerialize{

/// 主键
int? id;

/// 日志时间
int? date;

/// sql文
String? sql;

/// 参数Json
String? param;

/// 状态 0：待执行 1：执行完成 2：执行失败
int? state;

/// 日志来源IP
String? source;

/// 错误消息
String? err;
SqlLogErrorModel({required this.date,required this.err,required this.id,required this.param,required this.source,required this.sql,required this.state});
static SqlLogErrorModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return SqlLogErrorModel.fromMap(map);
}static SqlLogErrorModel fromMap(Map<String, dynamic> map){
    return SqlLogErrorModel(date: map["date"],err: map["err"],id: map["id"],param: map["param"],source: map["source"],sql: map["sql"],state: map["state"]);
}static List<SqlLogErrorModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return SqlLogErrorModel.fromMapList(list);
}static List<SqlLogErrorModel> fromMapList(List<dynamic> list){
    return list.map((map) => SqlLogErrorModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "date" : this.date,
"err" : this.err,
"id" : this.id,
"param" : this.param,
"source" : this.source,
"sql" : this.sql,
"state" : this.state,
                };}