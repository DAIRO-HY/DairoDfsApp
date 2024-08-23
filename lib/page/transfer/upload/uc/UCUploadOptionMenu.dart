import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import '../../../../db/dao/UploadDao.dart';
import '../../../../uc/UCOptionMenuButton.dart';
import '../../../../uc/dialog/UCAlertDialog.dart';
import '../../../../util/upload/UploadTask.dart';
import '../UploadPage.dart';

///操作菜单自定义组件
class UCUploadOptionMenu extends StatelessWidget {
  ///重新绘制操作菜单标记
  final redrawVN = ValueNotifier(0);

  var menus = <UCOptionMenuButton>[];

  ///文件传输子页面
  final UploadPageState state;

  ///当前选中的id列表
  late final selectedIds = this.state.selectedIds;

  late BuildContext _context;

  UCUploadOptionMenu(this.state, {super.key});

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
      UCOptionMenuButton("全选", icon: Icons.library_add_check_outlined, onPressed: this.onCheckAllClick),
      UCOptionMenuButton("全取消", icon: Icons.indeterminate_check_box_outlined, disabled: selectedCount == 0, onPressed: this.onUncheckAllClick),
      UCOptionMenuButton("移除", icon: Icons.cleaning_services_rounded, disabled: selectedCount == 0, onPressed: this.onRemoveClick),
    ];
    this.redrawVN.value++;
  }

  ///全选
  void onCheckAllClick() {
    this.selectedIds.clear();
    this.selectedIds.addAll(this.state.notUploadIds);
    this.selectedIds.addAll(this.state.finishIds);
    this.state.redraw();
    this.redraw();
  }

  void onUncheckAllClick() {
    this.selectedIds.clear();
    this.state.redraw();
    this.redraw();
  }

  ///移除按钮点击事件
  void onRemoveClick() {
    UCAlertDialog.show(this._context, msg: "确定要移除选中的个${this.selectedIds.length}下载文件？", okFun: () {
      final deleteIds = this.selectedIds.join(",");
      UploadDao.deleteByIds(deleteIds);

      //从正在下载列表中移除
      UploadTask.uploadingId2Bridge.forEach((id, bridge) {
        if (this.selectedIds.contains(id)) {
          bridge.pause();
        }
      });
      this.selectedIds.clear();
      UploadTask.start();
      this.state.reload();
    }, cancelFun: () {});
  }
}
