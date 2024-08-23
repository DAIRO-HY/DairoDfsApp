
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';

class TrashModel extends JsonSerialize{

/// 文件id
int? id;

/// 名称
String? name;

/// 大小
String? size;

/// 是否文件
bool? fileFlag;

/// 删除日期
String? date;
TrashModel({required this.date,required this.fileFlag,required this.id,required this.name,required this.size});
static TrashModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return TrashModel.fromMap(map);
}static TrashModel fromMap(Map<String, dynamic> map){
    return TrashModel(date: map["date"],fileFlag: map["fileFlag"],id: map["id"],name: map["name"],size: map["size"]);
}static List<TrashModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return TrashModel.fromMapList(list);
}static List<TrashModel> fromMapList(List<dynamic> list){
    return list.map((map) => TrashModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "date" : this.date,
"fileFlag" : this.fileFlag,
"id" : this.id,
"name" : this.name,
"size" : this.size,
                };}