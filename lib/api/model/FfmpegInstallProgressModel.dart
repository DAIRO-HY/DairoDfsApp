
/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';

class FfmpegInstallProgressModel extends JsonSerialize{


/// 是否正在下载
bool hasRuning;

/// 是否已经安装完成
bool hasFinish;

/// 文件总大小
String total;

/// 已经下载大小
String downloadedSize;

/// 下载速度
String speed;

/// 下载进度
int progress;

/// 下载url
String? url;

/// 安装信息
String? info;

/// 错误信息
String? error;
FfmpegInstallProgressModel({required this.downloadedSize,required this.error,required this.hasFinish,required this.hasRuning,required this.info,required this.progress,required this.speed,required this.total,required this.url});
static FfmpegInstallProgressModel fromJson(String json){
    Map<String,dynamic> map = jsonDecode(json);
    return FfmpegInstallProgressModel.fromMap(map);
}static FfmpegInstallProgressModel fromMap(Map<String, dynamic> map){
    return FfmpegInstallProgressModel(downloadedSize: map["downloadedSize"],error: map["error"],hasFinish: map["hasFinish"],hasRuning: map["hasRuning"],info: map["info"],progress: map["progress"],speed: map["speed"],total: map["total"],url: map["url"]);
}static List<FfmpegInstallProgressModel> fromJsonList(String json){
    List<dynamic> list = jsonDecode(json);
    return FfmpegInstallProgressModel.fromMapList(list);
}static List<FfmpegInstallProgressModel> fromMapList(List<dynamic> list){
    return list.map((map) => FfmpegInstallProgressModel.fromMap(map)).toList();
}              @override
              toJson()=> {
                "downloadedSize" : this.downloadedSize,
"error" : this.error,
"hasFinish" : this.hasFinish,
"hasRuning" : this.hasRuning,
"info" : this.info,
"progress" : this.progress,
"speed" : this.speed,
"total" : this.total,
"url" : this.url,
                };}