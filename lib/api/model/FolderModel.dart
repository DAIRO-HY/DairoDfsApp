
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';

class FolderModel extends JsonSerialize{

/// 名称
String? name;

/// 大小
String? size;

/// 是否文件
bool? fileFlag;

/// 创建日期
String? date;
FolderModel({required this.date,required this.fileFlag,required this.name,required this.size});
static FolderModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return FolderModel.fromMap(map);
}static FolderModel fromMap(Map<String, dynamic> map){
    return FolderModel(date: map["date"],fileFlag: map["fileFlag"],name: map["name"],size: map["size"]);
}static List<FolderModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return FolderModel.fromMapList(list);
}static List<FolderModel> fromMapList(List<dynamic> list){
    return list.map((map) => FolderModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "date" : this.date,
"fileFlag" : this.fileFlag,
"name" : this.name,
"size" : this.size,
                };}