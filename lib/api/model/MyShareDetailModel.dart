
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class MyShareDetailModel extends JsonSerialize{

/// id
int? id;

/// 链接
String? url;

/// 加密分享
String? pwd;

/// 分享的文件夹
String? folder;

/// 分享的文件夹或文件名,用|分割
String? names;

/// 结束日期
String? endDate;

/// 创建日期
String? date;
MyShareDetailModel({required this.date,required this.endDate,required this.folder,required this.id,required this.names,required this.pwd,required this.url});
static MyShareDetailModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return MyShareDetailModel.fromMap(map);
}static MyShareDetailModel fromMap(Map<String, dynamic> map){
    return MyShareDetailModel(date: map["date"],endDate: map["endDate"],folder: map["folder"],id: map["id"],names: map["names"],pwd: map["pwd"],url: map["url"]);
}static List<MyShareDetailModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return MyShareDetailModel.fromMapList(list);
}static List<MyShareDetailModel> fromMapList(List<dynamic> list){
    return list.map((map) => MyShareDetailModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "date" : this.date,
"endDate" : this.endDate,
"folder" : this.folder,
"id" : this.id,
"names" : this.names,
"pwd" : this.pwd,
"url" : this.url,
                };}