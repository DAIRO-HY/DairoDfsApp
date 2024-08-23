import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/api/TrashApi.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import '../../../uc/dialog/UCAlertDialog.dart';
import '../../../util/Toast.dart';
import '../TrashPage.dart';
import 'UCTrashOptionMenuButton.dart';

///操作菜单自定义组件
class UCTrashOptionMenu extends StatelessWidget {
  ///重新绘制操作菜单标记
  final redrawVN = ValueNotifier(0);

  var menus = <UCTrashOptionMenuButton>[];

  ///文件页面状态对象
  final TrashPageState trashPageState;

  late BuildContext _context;

  UCTrashOptionMenu(this.trashPageState, {super.key});

  @override
  Widget build(BuildContext context) {
    this._context = context;
    return this.redrawVN.build(
        (value) => Container(decoration: BoxDecoration(color: context.color.primaryContainer), child: Row(children: this.menus)));
  }

  ///重新绘制
  void redraw() {
    //当前被选中的文件数量
    int selectedCount = this.trashPageState.selectedCount;
    this.menus = [
      UCTrashOptionMenuButton("全选", icon: Icons.library_add_check_outlined, onPressed: this.onCheckAllClick),
      UCTrashOptionMenuButton("全取消", icon: Icons.indeterminate_check_box_outlined, disabled: selectedCount == 0, onPressed: this.onUncheckAllClick),
      UCTrashOptionMenuButton("还原", icon: Icons.settings_backup_restore_outlined, disabled: selectedCount == 0, onPressed: this.onRecoverClick),
      UCTrashOptionMenuButton("彻底删除", icon: Icons.delete_forever_outlined, disabled: selectedCount == 0, onPressed: this.onDeleteClick),
      //UCOptionMenuButton("清空回收站", icon: Icons.paste_outlined, disabled: UCOptionMenu.clipboardType == null, onPressed: this.onClipboardClick),
    ];
    this.redrawVN.value++;
  }

  ///全选
  void onCheckAllClick() {
    for (var it in this.trashPageState.ucTrashList.dfsFileList) {
      it.isSelected = true;
    }
    this.trashPageState.selectedCount = this.trashPageState.ucTrashList.dfsFileList.length;
    this.redraw();
    this.trashPageState.ucTrashList.redraw();
  }

  ///全取消
  void onUncheckAllClick() {
    for (var it in this.trashPageState.ucTrashList.dfsFileList) {
      it.isSelected = false;
    }
    this.trashPageState.selectedCount = 0;
    this.redraw();
    this.trashPageState.ucTrashList.redraw();
  }

  ///删除
  void onDeleteClick() {
    UCAlertDialog.show(this._context, title: "删除确认", msg: "确定要彻底删除选中的${this.trashPageState.selectedCount}个文件或文件夹吗？", okFun: () {
      TrashApi.logicDelete(ids: this.trashPageState.ucTrashList.selectedPaths).post(() async{
        this._context.toast("${this.trashPageState.selectedCount}个文件或文件夹已彻底删除");
        this.trashPageState.ucTrashList.loadData();
      }, this._context);
    }, cancelFun: () {});
  }

  ///还原
  void onRecoverClick() {
    UCAlertDialog.show(this._context, title: "还原确认", msg: "确定要还原选中的${this.trashPageState.selectedCount}个文件或文件夹吗？", okFun: () {
      TrashApi.trashRecover(ids: this.trashPageState.ucTrashList.selectedPaths).post(() async{
        this._context.toast("${this.trashPageState.selectedCount}个文件或文件夹已还原");
        this.trashPageState.ucTrashList.loadData();
      }, this._context);
    }, cancelFun: () {});
  }
}
