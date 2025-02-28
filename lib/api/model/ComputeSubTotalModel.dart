/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class ComputeSubTotalModel extends JsonSerialize {

  /** 大小 **/
  int size;

  /** 文件数(文件夹属性专用) **/
  int fileCount;

  /** 文件夹数(文件夹属性专用) **/
  int folderCount;

  ComputeSubTotalModel(
      {      required this.size,
      required this.fileCount,
      required this.folderCount});

  /// 将model转Json
  @override
  toJson() => {
        "size": this.size,
        "fileCount": this.fileCount,
        "folderCount": this.folderCount,
      };

  /// 将json字符串转ComputeSubTotalModel对象
  static ComputeSubTotalModel fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return ComputeSubTotalModel.fromMap(map);
  }

  /// 将Map对象转ComputeSubTotalModel对象
  static ComputeSubTotalModel fromMap(Map<String, dynamic> map) {
    return ComputeSubTotalModel(
        size: map["size"],
        fileCount: map["fileCount"],
        folderCount: map["folderCount"]);
  }

  /// 将Json字符串转ComputeSubTotalModel对象列表
  static List<ComputeSubTotalModel> fromJsonList(String json) {
    List<dynamic> list = jsonDecode(json);
    return ComputeSubTotalModel.fromMapList(list);
  }

  /// 将List<Map>对象转ComputeSubTotalModel对象列表
  static List<ComputeSubTotalModel> fromMapList(List<dynamic> list) {
    return list.map((map) => ComputeSubTotalModel.fromMap(map)).toList();
  }
}
