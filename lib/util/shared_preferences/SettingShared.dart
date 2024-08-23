import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:dairo_dfs_app/bean/AccountInfo.dart';
import 'package:dairo_dfs_app/code/FileSortType.dart';
import 'package:dairo_dfs_app/extension/List++.dart';
import 'package:dairo_dfs_app/extension/String++.dart';
import 'package:dairo_dfs_app/util/even_bus/EventCode.dart';
import 'package:dairo_dfs_app/util/even_bus/EventUtil.dart';
import '../../Const.dart';
import '../../api/LoginApi.dart';
import '../../api/UserApi.dart';
import '../../api/model/UserInfoModel.dart';
import '../../code/FileOrderBy.dart';
import '../../code/FileViewType.dart';
import '../../code/VideoQualityCode.dart';
import '../SyncVariable.dart';
import 'DfsFileShared.dart';

/// 用户设置
class SettingShared {
/*----------------------------------------------------------------------------------*/

  /// 会员信息
  static const _KEY_USER = "USER";

  /// <summary>
  /// 会员信息
  /// </summary>
  static UserInfoModel? get user => SettingShared._KEY_USER.localObj(UserInfoModel.fromJson);

  static set user(value) {
    SettingShared._KEY_USER.toLocalObj(value);
  }

  /// 后台加载会员信息,不弹出加载等待框
  /// [force] 是否强制刷新数据
  static loadInBackground() {
    // if (!force && SettingShared.user != null){//非强制刷新的情况下,如果已经加载过,就不需要再加载数据
    //     return;
    // }
    UserApi.getUserInfo().post((user) async{
      SettingShared.user = user;
    });
  }

/*----------------------------------------------------------------------------------*/

  /// 登录Token
  static const _KEY_TOKEN = "TOKEN";
  static String? _token;

  /// <summary>
  /// 登录Token
  /// </summary>
  static String? get token {
    SettingShared._token ??= SyncVariable.sPrefs.getString(SettingShared._KEY_TOKEN);
    return SettingShared._token;
  }

  static set token(value) {
    SettingShared._token = value;
    if (value == null) {
      SyncVariable.sPrefs.remove(SettingShared._KEY_TOKEN);
      return;
    }
    SyncVariable.sPrefs.setString(SettingShared._KEY_TOKEN, value);
  }

/*----------------------------------------------------------------------------------*/

  /// 主题模式
  static const _THEME = "THEME";

  static int get theme {
    return SyncVariable.sPrefs.getInt(SettingShared._THEME) ?? 0;
  }

  static set theme(value) {
    SyncVariable.sPrefs.setInt(SettingShared._THEME, value);
  }

/*----------------------------------------------------------------------------------*/

  /// 当前服务器域名
  static const _DOMAIN = "DOMAIN";
  static String? _domain;

  static String get domainNotNull => SettingShared.domain ?? "";

  static String? get domain {
    SettingShared._domain ??= SyncVariable.sPrefs.getString(SettingShared._DOMAIN);
    return SettingShared._domain;
  }

  static set domain(value) {
    SettingShared._domain = value;
    if (value == null) {
      SyncVariable.sPrefs.remove(SettingShared._DOMAIN);
      return;
    }
    SyncVariable.sPrefs.setString(SettingShared._DOMAIN, value);
  }

/*----------------------------------------------------------------------------------*/

  /// 登录过的用户列表
  static List<AccountInfo> get logined => "logined".localObj(AccountInfo.fromJsonList) ?? [];

  static set logined(value) {
    "logined".toLocalObj(value);
    SettingShared._token = null;
  }

/*----------------------------------------------------------------------------------*/

  /// 同时下载文件数
  static int get downloadSyncCount => SyncVariable.sPrefs.getInt("DOWNLOAD_SYNC_COUNT") ?? 1;

  static set downloadSyncCount(int value) {
    SyncVariable.sPrefs.setInt("DOWNLOAD_SYNC_COUNT", value);
  }

/*----------------------------------------------------------------------------------*/

  /// 同时上传文件数
  static int get uploadSyncCount => SyncVariable.sPrefs.getInt("UPLOAD_SYNC_COUNT") ?? 1;

  static set uploadSyncCount(int value) {
    SyncVariable.sPrefs.setInt("UPLOAD_SYNC_COUNT", value);
  }

/*----------------------------------------------------------------------------------*/

  ///记录当前打开的文件夹
  static const _CURRENT_PATH = "CURRENT_PATH";

  ///获取最后一次打开的文件夹
  static String get lastOpenFolder => SyncVariable.sPrefs.getString(SettingShared._CURRENT_PATH) ?? "";

  static set lastOpenFolder(value) => SyncVariable.sPrefs.setString(SettingShared._CURRENT_PATH, value);

/*----------------------------------------------------------------------------------*/

  /// 排列方式
  static int get sortType => SyncVariable.sPrefs.getInt("SORT_TYPE") ?? FileSortType.NAME;

  static set sortType(int value) {
    SyncVariable.sPrefs.setInt("SORT_TYPE", value);
  }

/*----------------------------------------------------------------------------------*/

  /// 排列升降序
  static int get sortOrderBy => SyncVariable.sPrefs.getInt("SORT_ORDER_BY") ?? FileOrderBy.UP;

  static set sortOrderBy(int value) {
    SyncVariable.sPrefs.setInt("SORT_ORDER_BY", value);
  }

/*----------------------------------------------------------------------------------*/

  /// 文件列表或表格显示类型
  static int get viewType {
    final value = SyncVariable.sPrefs.getInt("VIEW_TYPE");
    if (value != null) {
      return value;
    }
    if (Platform.isIOS || Platform.isAndroid) {
      //移动端默认以列表显示
      return FileViewType.LIST;
    }
    return FileViewType.GRID;
  }

  static set viewType(int value) {
    SyncVariable.sPrefs.setInt("VIEW_TYPE", value);
  }

/*----------------------------------------------------------------------------------*/

  /// 文件下载目录
  static String get downloadPath {
    final path = SyncVariable.sPrefs.getString("DOWNLOAD_PATH");
    if (path != null) {
      return path;
    }
    if (Platform.isIOS) {
      return SyncVariable.documentPath + "/download";
    } else if (Platform.isAndroid) {
      return SyncVariable.downloadPath;
    } else if (Platform.isMacOS) {
      return SyncVariable.supportPath + "/download";
    } else if (Platform.isLinux) {
      return SyncVariable.downloadPath;
    } else if (Platform.isWindows) {
      return SyncVariable.supportPath + "/download";
    } else
      return "";
  }

  static set downloadPath(String value) {
    SyncVariable.sPrefs.setString("DOWNLOAD_PATH", value);
  }

/*----------------------------------------------------------------------------------*/

  /// 视频播放质量
  static int get videoQuality {
    return SyncVariable.sPrefs.getInt("VIDEO_QUALITY") ?? VideoQualityCode.NORMAL;
  }

  static set videoQuality(int value) {
    SyncVariable.sPrefs.setInt("VIDEO_QUALITY", value);
  }

/*----------------------------------------------------------------------------------*/

  /// 是否登录
  static bool get isLogin => SettingShared.token != null;

  /// 退出登录
  static logout() {
    final logined = SettingShared.logined;
    logined.forEach((it) => it.isLogining = false);
    SettingShared.logined = logined;
    SettingShared.token = null;
  }

  /// 登录
  static Future<void> login(
      AccountInfo loginInfo, BuildContext context, VoidCallback success, bool Function(int code, String msg, Object? data) fail) async {
    //先记录登录之前的服务器，如果登录失败，则还原之前的服务器
    var oldDomain = SettingShared.domain;
    SettingShared.domain = loginInfo.domain;
    LoginApi.doLogin(name: loginInfo.name, pwd: loginInfo.pwd, deviceId: await Const.deviceId).fail((code, msg, data) async{
      //登录失败，将服务器还原
      SettingShared.domain = oldDomain;
      return fail(code, msg, data);
    }).post((token) async{
      //登录成功
      final logined = SettingShared.logined;
      for (final it in logined) {
        it.isLogining = false;
      }
      final curentInfo = logined.find((it) => it.domain == loginInfo.domain && it.name == loginInfo.name);
      if (curentInfo == null) {
        loginInfo.isLogining = true;
        logined.add(loginInfo);
      } else {
        //将其标记为登录状态
        curentInfo.isLogining = true;
      }
      SettingShared.logined = logined;
      SettingShared.token = token;

      //后台加载用户信息
      SettingShared.loadInBackground();

      //清空缓存的文件列表
      DfsFileShared.clear();

      //通知登录账户更新
      EventUtil.post(EventCode.ACCOUNT_CHANGE);
      success();
    }, context);
  }
}
