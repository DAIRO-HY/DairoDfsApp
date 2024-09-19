import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart' as crypto;
import 'package:dairo_dfs_app/util/SyncVariable.dart';

import '../util/shared_preferences/SettingShared.dart';

extension StringExtension on String {
  /// 获取字符串的MD5
  String get md5 {
    // 将字符串转换为字节
    List<int> bytes = utf8.encode(this);

    // 计算 MD5 哈希值
    final md5Result = crypto.md5.convert(bytes);
    return md5Result.toString();
  }

  /// 将一个对象序列化到本地文件
  /// return 是否有写入文件,若写入前后内容一样,则不重复写入文件
  bool toLocalObj(Object? obj) {
    //保存目录
    final file = File(SyncVariable.supportPath + "/obj-data/$this.json");
    if (obj == null) {
      if (file.existsSync()) {
        //先判断文件是否存在,否则可能会报错
        file.deleteSync();
      }
      return true;
    }

    String json = jsonEncode(obj);
    if (file.existsSync()) {
      //读取文件类容
      final oldJson = file.readAsStringSync();
      if (json == oldJson) {
        //避免重复写入，频繁写入会影响磁盘寿命，但读不会
        return false;
      }
    } else {
      //文件不存在,创建文件
      file.createSync(recursive: true);
    }
    file.writeAsStringSync(json);
    return true;
  }

  /// 从本地序列化文件读取到实列
  T? localObj<T>(T Function(String) fromJson) {
    //保存目录
    final file = File(SyncVariable.supportPath + "/obj-data/$this.json");
    if (!file.existsSync()) {
      return null;
    }

    //读取文件类容
    final json = file.readAsStringSync();
    try {
      return fromJson(json);
    } catch (e) {
      return null;
    }
  }

  /// 获取文件名
  String get fileName {
    final self = this.replaceAll("\\", "/");
    final splitIndex = self.lastIndexOf('/');
    if (splitIndex == -1) {
      return self;
    }
    return this.substring(splitIndex + 1);
  }

  /// 获取文件后缀名
  String get fileExt {
    final splitIndex = this.lastIndexOf('.');
    if (splitIndex == -1) {
      //根目录文件,没有父级文件夹
      return "";
    }
    return this.substring(splitIndex + 1);
  }

  /// 获取路径的父级文件夹路径
  String get fileParent {
    final self = this.replaceAll("\\", "/");
    final lastSplitIndex = self.lastIndexOf("/");
    if (lastSplitIndex == -1) {
      return "";
    }
    final parentFolder = self.substring(0, lastSplitIndex);
    return parentFolder;
  }

  /// 获取完成的API请求网址
  String get domainUrl {
    var url = this;

    //添加认证信息
    if (url.contains("?")) {
      url = "$url&_token=${SettingShared.token!}";
    } else {
      url = "$url?_token=${SettingShared.token!}";
    }
    url = SettingShared.domainNotNull + url;
    return url;
  }
}
