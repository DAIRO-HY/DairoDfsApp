
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';

class FilePropertyHistoryModel extends JsonSerialize{

/// 文件ID
int? id;

/// 大小
String? size;

/// 创建日期
String? date;

FilePropertyHistoryModel({required this.date,required this.id,required this.size});
static FilePropertyHistoryModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return FilePropertyHistoryModel.fromMap(map);
}static FilePropertyHistoryModel fromMap(Map<String, dynamic> map){
    return FilePropertyHistoryModel(date: map["date"],id: map["id"],size: map["size"]);
}static List<FilePropertyHistoryModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return FilePropertyHistoryModel.fromMapList(list);
}static List<FilePropertyHistoryModel> fromMapList(List<dynamic> list){
    return list.map((map) => FilePropertyHistoryModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "date" : this.date,
"id" : this.id,
"size" : this.size,
                };}