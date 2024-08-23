import 'dart:io';
import 'dart:ui';

import 'package:dairo_dfs_app/db/DBUtil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cache/AppCacheManager.dart';

///定义一些程序启动时需要的常量
class SyncVariable {
  ///标记是否已经初始化
  static var isInit = false;

  ///键值存储对象
  static late SharedPreferences sPrefs;

  ///缓存目录路径
  static late String cachePath;

  ///数据目录路径
  static late String supportPath;

  ///下载目录路径
  static late String downloadPath;

  ///文档目录路径
  static late String documentPath;

  static init(VoidCallback cb) {
    if (SyncVariable.isInit) {
      cb();
      return;
    }

    //初始化键值存储对象
    SharedPreferences.getInstance().then((sPrefs) {
      SyncVariable.sPrefs = sPrefs;

      //获取缓存目录
      getApplicationCacheDirectory().then((dic) {
        SyncVariable.cachePath = dic.path;
        if (!Directory(AppCacheManager.cacheFolder).existsSync()) {
          Directory(AppCacheManager.cacheFolder).create(recursive: true);
        }

        //获取数据存储目录
        getApplicationSupportDirectory().then((dic) {
          SyncVariable.supportPath = dic.path;

          //获取数据存储目录
          getDownloadsDirectory().then((dic) {
            SyncVariable.downloadPath = dic!.path;

            //获取文档存储目录
            getApplicationDocumentsDirectory().then((dic) {
              SyncVariable.documentPath = dic.path;

              //sqlite数据库初始化
              DBUtil.init().then((_) {
                cb();
              });
            });
          });
        });
      });
    });
  }
}
