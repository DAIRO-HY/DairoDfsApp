import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/db/DBUtil.dart';
import 'package:dairo_dfs_app/db/dao/DownloadDao.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/Number++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import '../../uc/dialog/UCAlertDialog.dart';
import '../../uc/item/ItemButton.dart';
import '../../uc/item/ItemGroup.dart';
import '../../util/cache/AppCacheManager.dart';
import '../../util/shared_preferences/DfsFileShared.dart';

/// 缓存页面
class CachePage extends StatefulWidget {
  const CachePage({super.key});

  @override
  State<CachePage> createState() => _CachePageState();
}

class _CachePageState extends State<CachePage> {
  ///今天天数
  final today = (DateTime.now().millisecondsSinceEpoch / 1000 / 60 / 60 / 24).toInt();

  ///缓存总大小
  var size = 0;

  ///缓存文件总数
  var count = 0;

  ///缓存计算通知
  final cacheSizeVN = ValueNotifier(0);

  ///文件缓存信息列表
  final cacheFileInfos = [
    _CacheInfo(0, "目前使用过"),
    _CacheInfo(1, "1天前使用过"),
    _CacheInfo(7, "1星期前使用过"),
    _CacheInfo(30, "1个月前使用过"),
    _CacheInfo(90, "3个月前使用过"),
    _CacheInfo(183, "半年前使用过")
  ];

  ///标记页面是否已经关闭
  var isFinish = false;

  ///标记是否正在处理中
  var isBusy = false;

  @override
  void initState() {
    super.initState();

    //页面加载完成之后回调事件
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await this.compute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("缓存管理")),
        body: Column(
          children: [
            Gap(20),
            Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: this.cacheSizeVN.build((value) {
                  final items = this.cacheFileInfos.map((it) {
                    final VoidCallback? onPressed;
                    if (this.isBusy || it.count == 0) {
                      onPressed = null;
                    } else {
                      onPressed = () {
                        this.onClearClick(it);
                      };
                    }
                    return ItemButton(
                      it.label,
                      tip: "${it.size.dataSize}(${it.count}个文件)",
                      onPressed: onPressed,
                    );
                  }).toList();
                  return Column(
                    children: [
                      ItemGroup(children: items),
                      Gap(20),
                      ItemGroup(children: [
                        ItemButton(
                          "全部缓存",
                          tip: "${this.size.dataSize}(${this.count}个文件)",
                          onPressed: (this.isBusy || this.count == 0) ? null : this.onClearAllClick,
                        )
                      ]),
                      Gap(20),
                      ItemGroup(children: [
                        ItemButton("当前使用内存", onPressed: () {
                          context.toast(ProcessInfo.currentRss.dataSize);
                        })
                      ])
                    ],
                  );
                }))
          ],
        ));
  }

  final set = HashSet<int>();
  List<int> list = [];

  ///计算缓存总量
  Future<void> compute() async {
    //标记正在处理中
    this.isBusy = true;

    //今天天数
    final today = (DateTime.now().millisecondsSinceEpoch / 1000 / 60 / 60 / 24).toInt();
    final folder = Directory(AppCacheManager.cacheFolder);
    await for (var it in folder.list()) {
      if (this.isFinish) {
        return;
      }
      final path = it.path;
      final file = File(path);
      if (path.endsWith(AppCacheManager.LAST_USE_DATE_FILE_END)) {
        final cacheDay = int.parse(file.readAsStringSync());

        //已经缓存的天数
        final days = today - cacheDay;

        //得到数据文件
        final dataFile = File(path.substring(0, path.length - AppCacheManager.LAST_USE_DATE_FILE_END.length));
        final int dataSize;
        final int count;
        if (dataFile.existsSync()) {
          //数据文件存在的话
          dataSize = dataFile.lengthSync() + file.lengthSync();
          count = 2;
        } else {
          dataSize = file.lengthSync();
          count = 1;
        }
        for (var it in this.cacheFileInfos) {
          if (days >= it.day) {
            it.size += dataSize;
            it.count += count;
          }
        }
      }
      //await Future.delayed(Duration(milliseconds: 50));
      this.size += File(path).lengthSync();
      this.count++;
      this.cacheSizeVN.value++;
    }

    //标记正在处理完成
    this.isBusy = false;
    this.cacheSizeVN.value++;
  }

  ///删除缓存点击事件
  ///[day] 指定天之前的数据
  void onClearClick(_CacheInfo info) {
    UCAlertDialog.show(context, msg: "确定删除${info.label}的缓存", cancelFun: () {}, okFun: () async {
      //标记正在处理中
      this.isBusy = true;
      final folder = Directory(AppCacheManager.cacheFolder);
      await for (var it in folder.list()) {
        if (this.isFinish) {
          return;
        }
        final path = it.path;
        final file = File(path);
        if (path.endsWith(AppCacheManager.LAST_USE_DATE_FILE_END)) {
          final cacheDay = int.parse(file.readAsStringSync());

          //已经缓存的天数
          final days = this.today - cacheDay;
          if (days >= info.day) {
            //得到数据文件
            final dataFile = File(path.substring(0, path.length - AppCacheManager.LAST_USE_DATE_FILE_END.length));
            final int dataSize;
            final int count;
            if (dataFile.existsSync()) {
              //数据文件存在的话
              dataSize = dataFile.lengthSync() + file.lengthSync();
              count = 2;
            } else {
              dataSize = file.lengthSync();
              count = 1;
            }
            for (var it in this.cacheFileInfos) {
              if (days >= it.day) {
                it.size -= dataSize;
                it.count -= count;
              }
            }

            this.size -= dataSize;
            this.count -= count;

            //删除文件
            file.deleteSync();
            if (dataFile.existsSync()) {
              dataFile.deleteSync();
            }
          }
        }
        //await Future.delayed(Duration(milliseconds: 50));
        this.cacheSizeVN.value++;
      }

      //标记正在处理完成
      this.isBusy = false;
      this.cacheSizeVN.value++;
    });
  }

  ///删除缓存点击事件
  ///[day] 指定天之前的数据
  void onClearAllClick() {
    UCAlertDialog.show(context, msg: "确定删除所有的缓存", cancelFun: () {}, okFun: () async {
      //标记正在处理中
      this.isBusy = true;
      final folder = Directory(AppCacheManager.cacheFolder);
      await for (var it in folder.list()) {
        if (this.isFinish) {
          return;
        }
        final path = it.path;
        final file = File(path);

        this.size -= file.lengthSync();
        this.count -= 1;

        //删除文件
        file.deleteSync();
        //await Future.delayed(Duration(milliseconds: 50));
        this.cacheSizeVN.value++;
      }
      for (final it in this.cacheFileInfos) {
        it.size = 0;
        it.count = 0;
      }

      //全部清除时,把DFS文件列表缓存也清除掉
      Directory(DfsFileShared.cacheFolderPath).deleteSync(recursive: true);

      //标记正在处理完成
      this.isBusy = false;
      this.cacheSizeVN.value++;
    });
  }

  @override
  void dispose() {
    super.dispose();
    this.isFinish = true;
  }
}

///缓存文件信息
class _CacheInfo {
  ///n天前标志
  final int day;

  ///标题
  final String label;

  ///文件数量
  var count = 0;

  ///数据大小
  var size = 0;

  _CacheInfo(this.day, this.label);
}
