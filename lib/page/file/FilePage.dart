import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/page/file/uc/UCFileOptionMenu.dart';
import 'package:dairo_dfs_app/page/home/uc/UCAddOption.dart';
import 'package:dairo_dfs_app/page/file/uc/UCFileList.dart';
import 'package:dairo_dfs_app/page/file/uc/UCFileToolBar.dart';
import 'package:dairo_dfs_app/util/even_bus/EventCode.dart';
import 'package:dairo_dfs_app/util/even_bus/EventUtil.dart';

import '../../util/shared_preferences/SettingShared.dart';

/// 文件列表页面
class FilePage extends StatefulWidget {
  const FilePage({super.key});

  @override
  State<FilePage> createState() => FilePageState();
}

class FilePageState extends State<FilePage> {
  ///是选择模式值监听
  final selectModeVN = ValueNotifier(false);

  ///当前文件夹改变监听器
  final currentFolderVN = ValueNotifier("");

  ///顶部工具条组件
  late var ucToolBar = UCFileToolBar(this);

  ///文件列表组件
  late var ucFileList = UCFileList(this);

  ///操作菜单组件
  late var ucOptionMenu = UCFileOptionMenu(this);

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
    EventUtil.regist(this, EventCode.FILE_PAGE_RELOAD, (data) {
      if (data != null && data != this.currentFolderVN.value) {
        //如果指定了更新某个文件夹
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
        body:
            Column(
              children: [
                this.ucToolBar, //顶部导航条
                this.ucFileList, //文件列表
                this.ucOptionMenu, //操作功能菜单
              ],
            )
    );
  }

  ///选择改变事件
  void onCheckChange(bool flag) {
    flag ? this.selectedCount++ : this.selectedCount--;
    if (this.selectedCount == 1) {
      //设置为选择模式
      this.selectModeVN.value = true;
      this.ucOptionMenu.redraw();
    } else if (this.selectedCount == 0) {
      this.selectModeVN.value = false;
      this.ucOptionMenu.hide();
    } else {
      ;
    }
    this.ucFileList.redraw();
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
