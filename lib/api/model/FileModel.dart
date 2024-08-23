
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';

class FileModel extends JsonSerialize{

/// 文件id
int id;

/// 名称
String name;

/// 大小
int size;

/// 是否文件
bool fileFlag;

/// 缩略图id
int? thumbId;

/// 创建日期
String date;
FileModel({required this.date,required this.fileFlag,required this.id,required this.name,required this.size,required this.thumbId});
static FileModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return FileModel.fromMap(map);
}static FileModel fromMap(Map<String, dynamic> map){
    return FileModel(date: map["date"],fileFlag: map["fileFlag"],id: map["id"],name: map["name"],size: map["size"],thumbId: map["thumbId"]);
}static List<FileModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return FileModel.fromMapList(list);
}static List<FileModel> fromMapList(List<dynamic> list){
    return list.map((map) => FileModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "date" : this.date,
"fileFlag" : this.fileFlag,
"id" : this.id,
"name" : this.name,
"size" : this.size,
"thumbId" : this.thumbId,
                };}