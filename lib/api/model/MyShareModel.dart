
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class MyShareModel extends JsonSerialize{

/// id
int? id;

/// 分享的文件夹或文件名
String? name;

/// 是否多文件
bool? multipleFlag;

/// 结束时间
String? endDate;

/// 创建日期
String? date;
MyShareModel({required this.date,required this.endDate,required this.id,required this.multipleFlag,required this.name});
static MyShareModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return MyShareModel.fromMap(map);
}static MyShareModel fromMap(Map<String, dynamic> map){
    return MyShareModel(date: map["date"],endDate: map["endDate"],id: map["id"],multipleFlag: map["multipleFlag"],name: map["name"]);
}static List<MyShareModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return MyShareModel.fromMapList(list);
}static List<MyShareModel> fromMapList(List<dynamic> list){
    return list.map((map) => MyShareModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "date" : this.date,
"endDate" : this.endDate,
"id" : this.id,
"multipleFlag" : this.multipleFlag,
"name" : this.name,
                };}