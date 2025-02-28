/*工具自动生成代码,请勿手动修改*/

import 'dart:convert';

import '../../util/JsonSerialize.dart';


class ProfileModel extends JsonSerialize {

  /** 记录同步日志 **/
  bool openSqlLog;

  /** 将当前服务器设置为只读,仅作为备份使用 **/
  bool hasReadOnly;

  /** 文件上传限制 **/
  int uploadMaxSize;

  /** 存储目录 **/
  String folders;

  /** 同步域名 **/
  String syncDomains;

  /** 分机与主机同步连接票据 **/
  String token;

  // 回收站超时(单位：天)
  int trashTimeout;

  // 删除没有被使用的文件超时设置(单位：天)
  int deleteStorageTimeout;

  ProfileModel(
      {      required this.openSqlLog,
      required this.hasReadOnly,
      required this.uploadMaxSize,
      required this.folders,
      required this.syncDomains,
      required this.token,
      required this.trashTimeout,
      required this.deleteStorageTimeout});

  /// 将model转Json
  @override
  toJson() => {
        "openSqlLog": this.openSqlLog,
        "hasReadOnly": this.hasReadOnly,
        "uploadMaxSize": this.uploadMaxSize,
        "folders": this.folders,
        "syncDomains": this.syncDomains,
        "token": this.token,
        "trashTimeout": this.trashTimeout,
        "deleteStorageTimeout": this.deleteStorageTimeout,
      };

  /// 将json字符串转ProfileModel对象
  static ProfileModel fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return ProfileModel.fromMap(map);
  }

  /// 将Map对象转ProfileModel对象
  static ProfileModel fromMap(Map<String, dynamic> map) {
    return ProfileModel(
        openSqlLog: map["openSqlLog"],
        hasReadOnly: map["hasReadOnly"],
        uploadMaxSize: map["uploadMaxSize"],
        folders: map["folders"],
        syncDomains: map["syncDomains"],
        token: map["token"],
        trashTimeout: map["trashTimeout"],
        deleteStorageTimeout: map["deleteStorageTimeout"]);
  }

  /// 将Json字符串转ProfileModel对象列表
  static List<ProfileModel> fromJsonList(String json) {
    List<dynamic> list = jsonDecode(json);
    return ProfileModel.fromMapList(list);
  }

  /// 将List<Map>对象转ProfileModel对象列表
  static List<ProfileModel> fromMapList(List<dynamic> list) {
    return list.map((map) => ProfileModel.fromMap(map)).toList();
  }
}
