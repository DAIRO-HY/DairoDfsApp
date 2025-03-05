import 'package:dairo_dfs_app/page/album/uc/AlbumGridView.dart';
import 'package:dairo_dfs_app/page/album/uc/AlbumOptionBarView.dart';
import 'package:dairo_dfs_app/page/album/uc/AlbumOptionView.dart';
import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/util/even_bus/EventCode.dart';
import 'package:dairo_dfs_app/util/even_bus/EventUtil.dart';

/// 文件列表页面
class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => AlbumPageState();
}

class AlbumPageState extends State<AlbumPage> {
  ///是选择模式值监听
  final selectModeVN = ValueNotifier(false);

  ///顶部工具条组件
  late var optionBar = AlbumOptionBarView(this);

  ///文件列表组件
  late var albumGrid = AlbumGridView(this);

  ///操作菜单组件
  late var albumOption = AlbumOptionView(this);

  ///标记页面是否被关闭
  var isFinish = false;

  ///当前被选中的文件数量
  var selectedCount = 0;

  @override
  void initState() {
    super.initState();

    //加载文件列表
    this.albumGrid.loadSubFile();
    EventUtil.regist(this, EventCode.FILE_PAGE_RELOAD, (_) {
      this.albumGrid.reload();
    });
    EventUtil.regist(this, EventCode.DFS_FILE_PAGE_GO_FOLDER, (data) {
      //打开某个文件夹
      this.albumGrid.loadSubFile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Column(
        children: [
          this.albumGrid, //文件列表
          this.albumOption, //操作功能菜单
        ],
      ),

      //操作按钮
      Positioned(right: 0, child: this.optionBar),
    ]));
  }

  ///选择改变事件
  void onCheckChange(bool flag) {
    flag ? this.selectedCount++ : this.selectedCount--;
    if (this.selectedCount == 1) {
      //设置为选择模式
      this.selectModeVN.value = true;
      this.albumOption.redraw();
    }
    // else if (this.selectedCount == 0) {
    //
    //   //隐藏底部操作菜单
    //   this.ucOptionMenu.hide();
    // } else {
    //   ;
    // }
  }

  ///页面被销毁时
  @override
  dispose() {
    super.dispose();
    this.isFinish = true;
    EventUtil.unregist(this);
  }
}
