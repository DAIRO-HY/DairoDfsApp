import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import 'package:dairo_dfs_app/uc/dialog/UCAlertDialog.dart';
import 'package:dairo_dfs_app/util/download/DownloadTask.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../db/dao/DownloadDao.dart';
import '../../../../uc/UCOptionMenuButton.dart';
import '../DownloadPage.dart';

///操作菜单自定义组件
class UCDownloadOptionMenu extends StatelessWidget {
  ///重新绘制操作菜单标记
  final redrawVN = ValueNotifier(0);

  var menus = <UCOptionMenuButton>[];

  ///文件传输子页面
  final DownloadPageState state;

  ///当前选中的id列表
  late final selectedIds = this.state.selectedIds;

  late BuildContext _context;

  UCDownloadOptionMenu(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    this._context = context;
    this.redraw();
    return SafeArea(
        top: false,
        child: Container(
            decoration: BoxDecoration(color: context.color.primaryContainer), child: this.redrawVN.build((value) => Row(children: this.menus))));
  }

  ///重新绘制
  void redraw() {
    //当前被选中的文件数量
    int selectedCount = this.state.selectedCount;
    this.menus = [
      UCOptionMenuButton("分享", icon: Icons.share, disabled: selectedCount == 0, onPressed: this.onShareClick),
      UCOptionMenuButton("全选", icon: Icons.library_add_check_outlined, onPressed: this.onCheckAllClick),
      UCOptionMenuButton("全取消", icon: Icons.indeterminate_check_box_outlined, disabled: selectedCount == 0, onPressed: this.onUncheckAllClick),
      UCOptionMenuButton("移除", icon: Icons.cleaning_services_rounded, disabled: selectedCount == 0, onPressed: this.onRemoveClick),
    ];
    this.redrawVN.value++;
  }

  ///分享
  void onShareClick() async {
    final ids = this.selectedIds.join(",");
    final dtoList = DownloadDao.selectByIds(ids);
    final shareFiles = <XFile>[];
    for (var it in dtoList) {
      if (it.state != 10) {
        continue;
      }
      // shareFile.add(XFile(it.path, mimeType: "video/mp4"));
      shareFiles.add(XFile(it.path));
    }
    await Share.shareXFiles(shareFiles);
  }

  ///全选
  void onCheckAllClick() {
    this.selectedIds.clear();
    this.selectedIds.addAll(this.state.notDownloadIds);
    this.selectedIds.addAll(this.state.finishIds);
    this.state.redraw();
    this.redraw();
  }

  void onUncheckAllClick() {
    this.selectedIds.clear();
    this.state.redraw();
    this.redraw();
  }

  ///清空按钮点击事件
  void onRemoveClick() {
    UCAlertDialog.show(this._context, msg: "确定要移除选中的个${this.selectedIds.length}下载文件？", okFun: () {
      final deleteIds = this.selectedIds.join(",");
      DownloadDao.deleteByIds(deleteIds);

      //从正在下载列表中移除
      DownloadTask.downloadingId2Bridge.forEach((id, bridge) {
        if (this.selectedIds.contains(id)) {
          bridge.pause();
        }
      });
      this.selectedIds.clear();
      DownloadTask.start();
      this.state.reload();
    }, cancelFun: () {});
  }
}
