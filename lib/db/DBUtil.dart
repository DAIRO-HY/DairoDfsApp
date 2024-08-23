import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dairo_dfs_app/extension/Database++.dart';
import 'package:dairo_dfs_app/util/SyncVariable.dart';
import 'package:sqlite3/sqlite3.dart';

class DBUtil {
  ///新版本号
  static const VERSION = 2;

  ///初始化
  static Future<void> init() async {
    // if (Platform.isWindows) {
    //   //针对windows初始化
    //   // 获取项目目录路径
    //   //final projectDir = path.dirname(Platform.script.toFilePath());
    //
    //   // 复制sqlite3.dll文件到项目目录
    //   final dllPath = "${SyncVariable.supportPath}/sqlite3.dll";
    //   if (!File(dllPath).existsSync()) {
    //     //如果文件不存在
    //     final byteData = await rootBundle.load('assets/sqlite3.dll');
    //     final buffer = byteData.buffer.asUint8List();
    //     final dllFile = File(dllPath);
    //     await dllFile.writeAsBytes(buffer);
    //   }
    //
    //   // 指定DLL文件路径
    //   DynamicLibrary.open(dllPath);//.close();
    // }
    await DBUtil._upgrade();
  }

  ///更新表结构
  static Future<void> _upgrade() async => await DBUtil.db.use((it) async {
        //得到旧版本版本号
        final oldVersion = it.userVersion;
        // if(oldVersion == 0){

          //下载列表
          await "download.sql".create(it);

          //上传列表
          await "upload.sql".create(it);
        // }
        if (oldVersion < 2) {
          it.exec("alter table download add saveToImageGallery INT1 not null default 0;");
        }

        //设置数据库版本号
        it.userVersion = DBUtil.VERSION;
      });

  static Database get db => sqlite3.open("${SyncVariable.supportPath}/db.sqlite");

  static void printMemoryUsage() {
    final memoryUsage = ProcessInfo.currentRss;
    print('Memory usage: ${memoryUsage / (1024 * 1024)} MB');
  }
}

extension _DBCreateExtension on String {
  ///创建
  Future<void> create(Database db) async {
    //如果文件不存在
    final sql = await rootBundle.loadString("assets/sql/$this");
    db.exec(sql);
  }
}

extension _DBExtension on Database {
  ///创建
  void exec(String sql) {
    try {
      this.execute(sql);
    } catch (e) {
      //尽管执行sql,忽略任何错误
      print(e);
    }
  }
}
