import 'dart:io';

import 'package:dairo_dfs_app/extension/String++.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/api/FilesApi.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import '../../../db/dao/UploadDao.dart';
import '../../../db/dto/UploadDto.dart';
import '../../../uc/UCOptionMenuButton.dart';
import '../../../uc/dialog/UCAlertDialog.dart';
import '../../../util/WaitDialog.dart';
import '../../../util/shared_preferences/SettingShared.dart';
import '../../../util/upload/UploadTask.dart';
import '../../home/HomePage.dart';
import '../../transfer/TransferPage.dart';
import '../AlbumPage.dart';

///操作菜单自定义组件
class AlbumOptionView extends StatelessWidget {

  ///重新绘制操作菜单标记
  final redrawVN = ValueNotifier(0);

  //底部操作按钮
  var optionMenu = <UCOptionMenuButton>[];

  ///文件页面状态对象
  final AlbumPageState albumPageState;

  late BuildContext _context;

  AlbumOptionView(this.albumPageState, {super.key});

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
      UCOptionMenuButton("上传", icon: Icons.add, onPressed: this.onAddClick),
      UCOptionMenuButton("删除", icon: Icons.delete_forever_outlined, disabled: selectedCount == 0, onPressed: this.onDeleteClick),
      UCOptionMenuButton("下载", icon: Icons.download_for_offline_outlined, disabled: selectedCount == 0, onPressed: this.onDownloadClick),
      UCOptionMenuButton("刷新", icon: Icons.refresh_outlined, onPressed: this.albumPageState.albumGrid.reload),
      UCOptionMenuButton("分享", icon: Icons.share, disabled: selectedCount == 0, onPressed: this.onShareClick),
      UCOptionMenuButton("退出", icon: Icons.exit_to_app, onPressed: this.onExitClick),
    ];
    this.redrawVN.value++;
  }

  ///删除
  void onDeleteClick() {
    UCAlertDialog.show(this._context, title: "删除确认", msg: "确定要删除选中的${this.albumPageState.selectedCount}个文件或文件夹吗？", okFun: () {
      FilesApi.deleteByIds(ids: this.albumPageState.albumGrid.selectedIds).post(() async {
        this.albumPageState.albumGrid.reload();
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

  ///上传按钮点击事件
  void onAddClick() async {
    Navigator.of(this._context).pop();

    //文件选择时可能需要从ICloud下载,需要花费时间,所以这里最好显示等待框
    WaitDialog.show(this._context);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      //压缩质量越低，文件大小越小，但图像质量也会随之降低。0-100。
      //compressionQuality: 1,

      //指定只选择文件类型。
      type: FileType.media,

      //自定义文件选择对话框的标题。
      dialogTitle: "选择上传文件",

      //锁定父窗口，使用户在文件选择对话框打开时无法与其他窗口内容进行交互。
      lockParentWindow: true,

      //允许多选
      allowMultiple: true,
    );
    WaitDialog.hide(this._context);
    if (result != null) {
      //获取最后一次打开的文件夹
      const uploadFolder = "/相册";
      final uploadDtoList = result.paths.map((it) {
        final dto = UploadDto(name: it!.fileName, size: File(it).lengthSync(), path: it, dfsFolder: uploadFolder);
        return dto;
      }).toList();

      //添加到数据库
      UploadDao.insert(uploadDtoList);
      UploadTask.start();

      this._context.toPage(TransferPage(pageTag: TransferPage.PAGE_UPLOAD));
    }
  }

  ///退出按钮点击事件
  void onExitClick(){
    this._context.relaunch(HomePage());
  }

  ///隐藏底部操作菜单
  void hide() {

    //将所有已选择取消
    for (var it in this.albumPageState.albumGrid.albumVMList) {
      it.isSelected = false;
    }
    this.albumPageState.selectedCount = 0;

    //取消选择模式
    this.albumPageState.selectModeVN.value = false;

    //0代表隐藏菜单工具
    this.redrawVN.value = 0;

    //页面重新绘制
    this.albumPageState.albumGrid.redraw();
  }
}
