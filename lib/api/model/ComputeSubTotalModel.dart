
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';

class ComputeSubTotalModel extends JsonSerialize{

/// 大小
int size;

/// 文件数(文件夹属性专用)
int fileCount;

/// 文件夹数(文件夹属性专用)
int folderCount;
ComputeSubTotalModel({required this.fileCount,required this.folderCount,required this.size});
static ComputeSubTotalModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return ComputeSubTotalModel.fromMap(map);
}static ComputeSubTotalModel fromMap(Map<String, dynamic> map){
    return ComputeSubTotalModel(fileCount: map["fileCount"],folderCount: map["folderCount"],size: map["size"]);
}static List<ComputeSubTotalModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return ComputeSubTotalModel.fromMapList(list);
}static List<ComputeSubTotalModel> fromMapList(List<dynamic> list){
    return list.map((map) => ComputeSubTotalModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "fileCount" : this.fileCount,
"folderCount" : this.folderCount,
"size" : this.size,
                };}