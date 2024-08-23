import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/db/DBUtil.dart';
import 'package:dairo_dfs_app/db/dao/DownloadDao.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import 'package:dairo_dfs_app/page/transfer/download/uc/UCDownloadItem.dart';
import 'package:dairo_dfs_app/util/download/DownloadBridge.dart';
import 'package:dairo_dfs_app/util/even_bus/EventUtil.dart';
import 'package:sqlite3/sqlite3.dart' as DATABASE;
import '../../../uc/dialog/UCAlertDialog.dart';
import '../../../util/download/DownloadTask.dart';
import '../../../util/even_bus/EventCode.dart';
import 'uc/UCDownloadOptionMenu.dart';

/// 文件传输页面
class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => DownloadPageState();
}

class DownloadPageState extends State<DownloadPage> {
  late final ucOptionMenu = UCDownloadOptionMenu(this);

  ///文件数量变更通知
  final updateVN = ValueNotifier(0);

  ///数据库连接
  DATABASE.Database? _db;

  ///所有没有下载id列表
  late List<int> notDownloadIds;

  ///所有已经下载完成的id列表
  late List<int> finishIds;

  ///当前选中的下载ID
  final selectedIds = HashSet<int>();

  ///当前被选中的文件数量
  int get selectedCount => this.selectedIds.length;

  @override
  void initState() {
    super.initState();
    this._db?.dispose();
    this._db = DBUtil.db;
    this.reload();
    EventUtil.regist(this, EventCode.DOWNLOAD_PROGRESS, (_) {
      this.redraw();
    });
    EventUtil.regist(this, EventCode.DOWNLOAD_PAGE_RELOAD, (_) {
      this.reload();
    });
  }

  @override
  void dispose() {
    super.dispose();
    this._db?.dispose();
    EventUtil.unregist(this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: this.updateVN.build((value) => ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: this.notDownloadIds.length + this.finishIds.length,
                itemBuilder: (context, index) {
                  final int id;
                  if (index < this.notDownloadIds.length) {
                    //未下载的列表
                    id = this.notDownloadIds[index];
                  } else {
                    //下载完成的列表
                    id = this.finishIds[index - this.notDownloadIds.length];
                  }

                  //如果该ID正在下载
                  var bridge = DownloadTask.downloadingId2Bridge[id];
                  if (bridge == null) {
                    final dto = DownloadDao.selectOneByDb(this._db!, id)!;
                    bridge = DownloadBridge(dto);
                  }

                  if (index == 0 && this.notDownloadIds.isNotEmpty) {
                    //如果当前正好是已完成下载的第一条数据
                    return Column(children: [
                      Gap(10),
                      Row(children: [
                        Gap(5),
                        context.textBody("进行中(${this.notDownloadIds.length})"),
                        Spacer(),
                        context.textButton(DownloadTask.downloadingId2Bridge.isEmpty ? "全部开始" : "全部暂停", onPressed: this.onAllDownloadOptionClick),
                        Gap(10)
                      ]),
                      UCDownloadItem(bridge, selectedIds: this.selectedIds, onSelectChange: this.onSelectChange)
                    ]);
                  } else if (index == this.notDownloadIds.length) {
                    //如果当前正好是已完成下载的第一条数据
                    return Column(children: [
                      Gap(20),
                      Row(children: [
                        Gap(10),
                        context.textBody("已完成(${this.finishIds.length})"),
                        Spacer(),
                        context.textButton("清空", onPressed: this.onClearFinishClick),
                        Gap(10)
                      ]),
                      UCDownloadItem(bridge, selectedIds: this.selectedIds, onSelectChange: this.onSelectChange)
                    ]);
                  } else {
                    return UCDownloadItem(bridge, selectedIds: this.selectedIds, onSelectChange: this.onSelectChange);
                  }
                }))),
        this.ucOptionMenu
      ],
    );
  }

  void onSelectChange(bool flag) {
    this.ucOptionMenu.redraw();
  }

  ///清楚已完成点击按钮
  void onAllDownloadOptionClick() {
    if (DownloadTask.downloadingId2Bridge.isEmpty) {
      //全部开始
      DownloadDao.downloadAll();
      DownloadTask.start();
    } else {
      //全部暂停
      DownloadDao.pauseAll();
      for (var it in DownloadTask.downloadingId2Bridge.values) {
        it.pause();
      }
    }
    this.redraw();
  }

  ///清楚已完成点击按钮
  void onClearFinishClick() {
    UCAlertDialog.show(context, msg: "确定要清空所有已完成的下载文件？", okFun: () {
      final deleteIds = this.finishIds.join(",");
      DownloadDao.deleteByIds(deleteIds);
      this.selectedIds.clear();
      this.reload();
    }, cancelFun: () {});
  }

  ///页面重绘
  void redraw() {
    this.updateVN.value++;
  }

  ///重新加载
  void reload() {
    this.notDownloadIds = DownloadDao.selectNotDownloadIds();
    this.finishIds = DownloadDao.selectFinishIds();
    this.redraw();
  }
}
