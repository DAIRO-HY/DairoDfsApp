/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class LibInstallProgressModel extends JsonSerialize {

  /** 是否正在下载 **/
  bool isRuning;

  /** 是否已经安装完成 **/
  bool isInstalled;

  /** 文件总大小 **/
  String total;

  /** 已经下载大小 **/
  String downloadedSize;

  /** 下载速度 **/
  String speed;

  /** 下载进度 **/
  int progress;

  /** 安装信息 **/
  String info;

  LibInstallProgressModel({required this.isRuning, required this.isInstalled, required this.total, required this.downloadedSize, required this.speed, required this.progress, required this.info});

  /// 将model转Json
  @override
  toJson() => {
        "isRuning": this.isRuning,
        "isInstalled": this.isInstalled,
        "total": this.total,
        "downloadedSize": this.downloadedSize,
        "speed": this.speed,
        "progress": this.progress,
        "info": this.info,
      };

  /// 将json字符串转LibInstallProgressModel对象
  static LibInstallProgressModel fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return LibInstallProgressModel.fromMap(map);
  }

  /// 将Map对象转LibInstallProgressModel对象
  static LibInstallProgressModel fromMap(Map<String, dynamic> map) {
    return LibInstallProgressModel(
        isRuning: map["isRuning"],
        isInstalled: map["isInstalled"],
        total: map["total"],
        downloadedSize: map["downloadedSize"],
        speed: map["speed"],
        progress: map["progress"],
        info: map["info"]);
  }

  /// 将Json字符串转LibInstallProgressModel对象列表
  static List<LibInstallProgressModel> fromJsonList(String json) {
    List<dynamic> list = jsonDecode(json);
    return LibInstallProgressModel.fromMapList(list);
  }

  /// 将List<Map>对象转LibInstallProgressModel对象列表
  static List<LibInstallProgressModel> fromMapList(List<dynamic> list) {
    return list.map((map) => LibInstallProgressModel.fromMap(map)).toList();
  }
}
