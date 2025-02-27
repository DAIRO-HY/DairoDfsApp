/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';
import 'FilePropertyHistoryModel.dart';
import 'FilePropertyHistoryModel.dart';

class FilePropertyModel extends JsonSerialize {
  /** 名称 **/
  String name;

  /** 路径 **/
  String path;

  /** 大小 **/
  String size;

  /** 文件类型(文件专用) **/
  String contentType;

  /** 创建日期 **/
  String date;

  /** 是否文件 **/
  bool isFile;

  /** 文件数(文件夹属性专用) **/
  int fileCount;

  /** 文件夹数(文件夹属性专用) **/
  int folderCount;

  /** 历史记录(文件属性专用) **/
  List<FilePropertyHistoryModel> historyList;

  FilePropertyModel(
      {required this.name,
      required this.path,
      required this.size,
      required this.contentType,
      required this.date,
      required this.isFile,
      required this.fileCount,
      required this.folderCount,
      required this.historyList});

  /// 将model转Json
  @override
  toJson() => {
        "name": this.name,
        "path": this.path,
        "size": this.size,
        "contentType": this.contentType,
        "date": this.date,
        "isFile": this.isFile,
        "fileCount": this.fileCount,
        "folderCount": this.folderCount,
        "historyList": this.historyList,
      };

  /// 将json字符串转FilePropertyModel对象
  static FilePropertyModel fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return FilePropertyModel.fromMap(map);
  }

  /// 将Map对象转FilePropertyModel对象
  static FilePropertyModel fromMap(Map<String, dynamic> map) {
    return FilePropertyModel(
        name: map["name"],
        path: map["path"],
        size: map["size"],
        contentType: map["contentType"],
        date: map["date"],
        isFile: map["isFile"],
        fileCount: map["fileCount"],
        folderCount: map["folderCount"],
        historyList: FilePropertyHistoryModel.fromMapList(map["historyList"]));
  }

  /// 将Json字符串转FilePropertyModel对象列表
  static List<FilePropertyModel> fromJsonList(String json) {
    List<dynamic> list = jsonDecode(json);
    return FilePropertyModel.fromMapList(list);
  }

  /// 将List<Map>对象转FilePropertyModel对象列表
  static List<FilePropertyModel> fromMapList(List<dynamic> list) {
    return list.map((map) => FilePropertyModel.fromMap(map)).toList();
  }
}
