import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/api/FilesApi.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import '../../../uc/UCOptionMenuButton.dart';
import '../../../uc/dialog/UCAlertDialog.dart';
import '../../file/uc/UCShare.dart';
import '../../home/HomePage.dart';
import '../AlbumPage.dart';
import 'UCDownloadWaitDialog.dart';

///操作菜单自定义组件
class UCAlbumOptionMenu extends StatelessWidget {

  ///重新绘制操作菜单标记
  final redrawVN = ValueNotifier(0);

  //底部操作按钮
  var optionMenu = <UCOptionMenuButton>[];

  ///文件页面状态对象
  final AlbumPageState albumPageState;

  late BuildContext _context;

  UCAlbumOptionMenu(this.albumPageState, {super.key});

  @override
  Widget build(BuildContext context) {
    this._context = context;
    return this.redrawVN.build((value) {
      if (value == 0) {
        return SizedBox();
      }
      return Container(
          decoration: BoxDecoration(color: context.color.primaryContainer),
          child: Column(children: [
            // Divider(height: .7, color: context.color.outline), // 加一条线
            // this.sortVN.build((value) => this.sortView),
            // Divider(height: .7, color: context.color.outline), // 加一条线
            Row(children: this.optionMenu),
          ]));
    });
  }

  ///重新绘制
  void redraw() {
    //当前被选中的文件数量
    int selectedCount = this.albumPageState.selectedCount;
    this.optionMenu = [
      // UCOptionMenuButton("全选", icon: Icons.library_add_check_outlined, onPressed: this.onCheckAllClick),
      UCOptionMenuButton("删除", icon: Icons.delete_forever_outlined, disabled: selectedCount == 0, onPressed: this.onDeleteClick),
      UCOptionMenuButton("下载", icon: Icons.download_for_offline_outlined, disabled: selectedCount == 0, onPressed: this.onDownloadClick),
      UCOptionMenuButton("刷新", icon: Icons.refresh_outlined, onPressed: this.albumPageState.ucAlbumListView.reload),
      UCOptionMenuButton("分享", icon: Icons.share, disabled: selectedCount == 0, onPressed: this.onShareClick),
      UCOptionMenuButton("退出", icon: Icons.exit_to_app, onPressed: this.onExitClick),
    ];
    this.redrawVN.value++;
  }

  ///删除
  void onDeleteClick() {
    UCAlertDialog.show(this._context, title: "删除确认", msg: "确定要删除选中的${this.albumPageState.selectedCount}个文件或文件夹吗？", okFun: () {
      FilesApi.deleteByIds(ids: this.albumPageState.ucAlbumListView.selectedIds).post(() async {
        this.albumPageState.ucAlbumListView.reload();
        this._context.toast("删除成功");
      }, this._context);
    }, cancelFun: () {});
  }

  ///下载按钮点击事件
  void onDownloadClick() async {
    // UCDownloadWaitDialog(this._context, this.albumPageState.ucAlbumListView.selected).show();
  }

  ///分享按钮点击事件
  void onShareClick(){
    // UCShare.show(this._context, this.albumPageState.ucAlbumListView.selectedPaths);
  }

  ///退出按钮点击事件
  void onExitClick(){
    this._context.relaunch(HomePage());
  }

  ///隐藏底部操作菜单
  void hide() {

    //将所有已选择取消
    for (var it in this.albumPageState.ucAlbumListView.albumVMList) {
      it.isSelected = false;
    }
    this.albumPageState.selectedCount = 0;

    //取消选择模式
    this.albumPageState.selectModeVN.value = false;

    //0代表隐藏菜单工具
    this.redrawVN.value = 0;

    //页面重新绘制
    this.albumPageState.ucAlbumListView.redraw();
  }
}
