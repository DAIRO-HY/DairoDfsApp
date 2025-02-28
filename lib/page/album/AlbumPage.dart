import 'package:dairo_dfs_app/page/album/uc/UCAlbumListView.dart';
import 'package:dairo_dfs_app/page/album/uc/UCAlbumOptionMenu.dart';
import 'package:dairo_dfs_app/page/album/uc/UCAlbumToolBar.dart';
import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/page/home/uc/UCAddOption.dart';
import 'package:dairo_dfs_app/util/even_bus/EventCode.dart';
import 'package:dairo_dfs_app/util/even_bus/EventUtil.dart';

import '../../util/shared_preferences/SettingShared.dart';

/// 文件列表页面
class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => AlbumPageState();
}

class AlbumPageState extends State<AlbumPage> {
  ///是选择模式值监听
  final selectModeVN = ValueNotifier(false);

  ///当前文件夹改变监听器
  final currentFolderVN = ValueNotifier("");

  ///顶部工具条组件
  late var ucToolBar = UCAlbumToolBar(this);

  ///文件列表组件
  late var ucFileList = UCAlbumListView(this);

  ///操作菜单组件
  late var ucOptionMenu = UCAlbumOptionMenu(this);

  ///标记页面是否被关闭
  var isFinish = false;

  ///当前被选中的文件数量
  var selectedCount = 0;

  @override
  void initState() {
    super.initState();

    //获取最后一次打开的文件夹
    final folder = SettingShared.lastOpenFolder;

    //加载文件列表
    this.ucFileList.loadSubFile(folder);
    EventUtil.regist(this, EventCode.FILE_PAGE_RELOAD, (_) {
      this.ucFileList.reload();
    });
    EventUtil.regist(this, EventCode.UPLOAD_PAGE_RELOAD, (data) {
      if (data != this.currentFolderVN.value) {
        //当前显示的文件夹和上传的文件夹不是同一个时,无需刷新
        return;
      }
      this.ucFileList.reload();
    });
    EventUtil.regist(this, EventCode.DFS_FILE_PAGE_GO_FOLDER, (data) {
      //打开某个文件夹
      this.ucFileList.loadSubFile(data as String);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Column(
        children: [
          this.ucFileList, //文件列表
          this.ucOptionMenu, //操作功能菜单
        ],
      ),

      //操作按钮
      Positioned(right: 0, child: this.ucToolBar),
    ]));
  }

  ///选择改变事件
  void onCheckChange(bool flag) {
    flag ? this.selectedCount++ : this.selectedCount--;
    if (this.selectedCount == 1) {
      //设置为选择模式
      this.selectModeVN.value = true;
      this.ucOptionMenu.redraw();
    }
    // else if (this.selectedCount == 0) {
    //
    //   //隐藏底部操作菜单
    //   this.ucOptionMenu.hide();
    // } else {
    //   ;
    // }
  }

  void showAddDialog() {
    UCAddOption.show(this.context);
  }

  ///页面被销毁时
  @override
  dispose() {
    super.dispose();
    this.isFinish = true;
    EventUtil.unregist(this);
  }
}
