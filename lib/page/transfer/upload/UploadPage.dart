import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import 'package:dairo_dfs_app/page/transfer/upload/uc/UCUploadOptionMenu.dart';
import '../../../db/DBUtil.dart';
import '../../../db/dao/UploadDao.dart';
import '../../../uc/dialog/UCAlertDialog.dart';
import '../../../util/even_bus/EventCode.dart';
import '../../../util/even_bus/EventUtil.dart';
import 'package:sqlite3/sqlite3.dart' as DATABASE;
import '../../../util/upload/UploadBridge.dart';
import '../../../util/upload/UploadTask.dart';
import 'uc/UCUploadItem.dart';

/// 文件传输页面
class UploadPage extends StatefulWidget {
  @override
  State<UploadPage> createState() => UploadPageState();
}

class UploadPageState extends State<UploadPage> {
  late final ucOptionMenu = UCUploadOptionMenu(this);

  ///文件数量变更通知
  final updateVN = ValueNotifier<int>(0);

  ///数据库连接
  DATABASE.Database? _db;

  ///所有没有下载id列表
  late List<int> notUploadIds;

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
    EventUtil.regist(this, EventCode.UPLOAD_PROGRESS, (_) {
      this.redraw();
    });
    EventUtil.regist(this, EventCode.UPLOAD_PAGE_RELOAD, (_) {
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
                itemCount: this.notUploadIds.length + this.finishIds.length,
                itemBuilder: (context, index) {
                  final int id;
                  if (index < this.notUploadIds.length) {
                    //未下载的列表
                    id = this.notUploadIds[index];
                  } else {
                    //下载完成的列表
                    id = this.finishIds[index - this.notUploadIds.length];
                  }

                  //如果该ID正在下载
                  var bridge = UploadTask.uploadingId2Bridge[id];
                  if (bridge == null) {
                    final dto = UploadDao.selectOneByDb(this._db!, id)!;
                    bridge = UploadBridge(dto);
                  }

                  if (index == 0 && this.notUploadIds.isNotEmpty) {
                    //如果当前正好是已完成下载的第一条数据
                    return Column(children: [
                      Gap(10),
                      Row(children: [
                        Gap(5),
                        context.textBody("进行中(${this.notUploadIds.length})"),
                        Spacer(),
                        context.textButton(UploadTask.uploadingId2Bridge.isEmpty ? "全部开始" : "全部暂停", onPressed: this.onAllUploadOptionClick),
                        Gap(10)
                      ]),
                      UCUploadItem(bridge, selectedIds: this.selectedIds, onSelectChange: this.onSelectChange)
                    ]);
                  } else if (index == this.notUploadIds.length) {
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
                      UCUploadItem(bridge, selectedIds: this.selectedIds, onSelectChange: this.onSelectChange)
                    ]);
                  } else {
                    return UCUploadItem(bridge, selectedIds: this.selectedIds, onSelectChange: this.onSelectChange);
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
  void onAllUploadOptionClick() {
    if (UploadTask.uploadingId2Bridge.isEmpty) {
      //全部开始
      UploadDao.uploadAll();
      UploadTask.start();
    } else {
      //全部暂停
      UploadDao.pauseAll();
      for (var it in UploadTask.uploadingId2Bridge.values) {
        it.pause();
      }
    }
    this.redraw();
  }

  ///清楚已完成点击按钮
  void onClearFinishClick() {
    UCAlertDialog.show(context, msg: "确定要清空所有已完成的下载文件？", okFun: () {
      final deleteIds = this.finishIds.join(",");
      UploadDao.deleteByIds(deleteIds);
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
    this.notUploadIds = UploadDao.selectNotUploadIds();
    this.finishIds = UploadDao.selectFinishIds();
    this.redraw();
  }
}
