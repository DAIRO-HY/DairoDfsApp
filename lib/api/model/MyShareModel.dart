
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class MyShareModel extends JsonSerialize{

/// id
int? id;

/// 分享的标题（文件名）
String? title;

/// 文件数量
int? fileCount;

/// 是否分享的仅仅是一个文件夹
bool? folderFlag;

/// 结束时间
String? endDate;

/// 创建日期
String? date;

/// 缩略图
String? thumb;
MyShareModel({required this.date,required this.endDate,required this.fileCount,required this.folderFlag,required this.id,required this.thumb,required this.title});
static MyShareModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return MyShareModel.fromMap(map);
}static MyShareModel fromMap(Map<String, dynamic> map){
    return MyShareModel(date: map["date"],endDate: map["endDate"],fileCount: map["fileCount"],folderFlag: map["folderFlag"],id: map["id"],thumb: map["thumb"],title: map["title"]);
}static List<MyShareModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return MyShareModel.fromMapList(list);
}static List<MyShareModel> fromMapList(List<dynamic> list){
    return list.map((map) => MyShareModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "date" : this.date,
"endDate" : this.endDate,
"fileCount" : this.fileCount,
"folderFlag" : this.folderFlag,
"id" : this.id,
"thumb" : this.thumb,
"title" : this.title,
                };}