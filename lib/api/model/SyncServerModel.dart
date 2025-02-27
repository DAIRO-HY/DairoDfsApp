/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class SyncServerModel extends JsonSerialize {

  /** 编号 **/
  int no;

  /** 主机端同步连接 **/
  String url;

  /** 同步状态 0：待机中 1：同步中 2：同步错误 **/
  int state;

  /** 同步消息 **/
  String msg;

  /** 同步日志数 **/
  int syncCount;

  /** 最后一次同步完成时间 **/
  String lastTime;

  /** 最后一次心跳时间 **/
  String lastHeartTime;

  SyncServerModel({required this.no, required this.url, required this.state, required this.msg, required this.syncCount, required this.lastTime, required this.lastHeartTime});

  /// 将model转Json
  @override
  toJson() => {
        "no": this.no,
        "url": this.url,
        "state": this.state,
        "msg": this.msg,
        "syncCount": this.syncCount,
        "lastTime": this.lastTime,
        "lastHeartTime": this.lastHeartTime,
      };

  /// 将json字符串转SyncServerModel对象
  static SyncServerModel fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return SyncServerModel.fromMap(map);
  }

  /// 将Map对象转SyncServerModel对象
  static SyncServerModel fromMap(Map<String, dynamic> map) {
    return SyncServerModel(
        no: map["no"],
        url: map["url"],
        state: map["state"],
        msg: map["msg"],
        syncCount: map["syncCount"],
        lastTime: map["lastTime"],
        lastHeartTime: map["lastHeartTime"]);
  }

  /// 将Json字符串转SyncServerModel对象列表
  static List<SyncServerModel> fromJsonList(String json) {
    List<dynamic> list = jsonDecode(json);
    return SyncServerModel.fromMapList(list);
  }

  /// 将List<Map>对象转SyncServerModel对象列表
  static List<SyncServerModel> fromMapList(List<dynamic> list) {
    return list.map((map) => SyncServerModel.fromMap(map)).toList();
  }
}
