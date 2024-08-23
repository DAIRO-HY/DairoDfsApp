
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';

class ShareModel extends JsonSerialize{

/// 名称
String? name;

/// 大小
String? size;

/// 是否文件
bool? fileFlag;

/// 创建日期
String? date;
ShareModel({required this.date,required this.fileFlag,required this.name,required this.size});
static ShareModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return ShareModel.fromMap(map);
}static ShareModel fromMap(Map<String, dynamic> map){
    return ShareModel(date: map["date"],fileFlag: map["fileFlag"],name: map["name"],size: map["size"]);
}static List<ShareModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return ShareModel.fromMapList(list);
}static List<ShareModel> fromMapList(List<dynamic> list){
    return list.map((map) => ShareModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "date" : this.date,
"fileFlag" : this.fileFlag,
"name" : this.name,
"size" : this.size,
                };}