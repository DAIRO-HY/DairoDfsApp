import 'package:dairo_dfs_app/api/MyShareApi.dart';
import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/api/TrashApi.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import '../../../uc/UCOptionMenuButton.dart';
import '../../../uc/dialog/UCAlertDialog.dart';
import '../MySharePage.dart';

///操作菜单自定义组件
class UCMyShareOptionMenu extends StatelessWidget {
  ///重新绘制操作菜单标记
  final redrawVN = ValueNotifier(0);

  var menus = <UCOptionMenuButton>[];

  ///文件页面状态对象
  final MySharePageState pageState;

  late BuildContext _context;

  UCMyShareOptionMenu(this.pageState, {super.key});

  @override
  Widget build(BuildContext context) {
    this._context = context;
    return this.redrawVN.build(
        (value) => Container(decoration: BoxDecoration(color: context.color.primaryContainer), child: Row(children: this.menus)));
  }

  ///重新绘制
  void redraw() {
    //当前被选中的文件数量
    int selectedCount = this.pageState.selectedCount;
    this.menus = [
      UCOptionMenuButton("全选", icon: Icons.library_add_check_outlined, onPressed: this.onCheckAllClick),
      UCOptionMenuButton("全取消", icon: Icons.indeterminate_check_box_outlined, disabled: selectedCount == 0, onPressed: this.onUncheckAllClick),
      UCOptionMenuButton("取消分享", icon: Icons.delete_forever_outlined, disabled: selectedCount == 0, onPressed: this.onDeleteClick),
    ];
    this.redrawVN.value++;
  }

  ///全选
  void onCheckAllClick() {
    for (var it in this.pageState.ucMyShareList.dfsFileList) {
      it.isSelected = true;
    }
    this.pageState.selectedCount = this.pageState.ucMyShareList.dfsFileList.length;
    this.redraw();
    this.pageState.ucMyShareList.redraw();
  }

  ///全取消
  void onUncheckAllClick() {
    for (var it in this.pageState.ucMyShareList.dfsFileList) {
      it.isSelected = false;
    }
    this.pageState.selectedCount = 0;
    this.redraw();
    this.pageState.ucMyShareList.redraw();
  }

  ///取消分享
  void onDeleteClick() {
    UCAlertDialog.show(this._context, title: "取消分享", msg: "确定要取消选中的${this.pageState.selectedCount}个分享吗？", okFun: () {
      MyShareApi.delete(ids: this.pageState.ucMyShareList.selectedPaths).post(() async{
        this._context.toast("${this.pageState.selectedCount}个分享已取消。");
        this.pageState.ucMyShareList.loadData();
      }, this._context);
    }, cancelFun: () {});
  }
}
