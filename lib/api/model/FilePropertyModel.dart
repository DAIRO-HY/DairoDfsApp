
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';
import 'FilePropertyHistoryModel.dart';

class FilePropertyModel extends JsonSerialize{

/// 名称
String? name;

/// 路径
String? path;

/// 大小
String? size;

/// 文件类型(文件专用)
String? contentType;

/// 创建日期
String? date;

/// 是否文件
bool? isFile;

/// 文件数(文件夹属性专用)
int? fileCount;

/// 文件夹数(文件夹属性专用)
int? folderCount;

/// 历史记录(文件属性专用)
List<FilePropertyHistoryModel>? historyList;
FilePropertyModel({required this.contentType,required this.date,required this.fileCount,required this.folderCount,required this.historyList,required this.isFile,required this.name,required this.path,required this.size});
static FilePropertyModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return FilePropertyModel.fromMap(map);
}static FilePropertyModel fromMap(Map<String, dynamic> map){
    return FilePropertyModel(contentType: map["contentType"],date: map["date"],fileCount: map["fileCount"],folderCount: map["folderCount"],historyList: map["historyList"] == null ? null : FilePropertyHistoryModel.fromMapList(map["historyList"]),isFile: map["isFile"],name: map["name"],path: map["path"],size: map["size"]);
}static List<FilePropertyModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return FilePropertyModel.fromMapList(list);
}static List<FilePropertyModel> fromMapList(List<dynamic> list){
    return list.map((map) => FilePropertyModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "contentType" : this.contentType,
"date" : this.date,
"fileCount" : this.fileCount,
"folderCount" : this.folderCount,
"historyList" : this.historyList,
"isFile" : this.isFile,
"name" : this.name,
"path" : this.path,
"size" : this.size,
                };}