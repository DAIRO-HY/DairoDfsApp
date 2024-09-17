import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/page/my_share/uc/UCMyShareList.dart';
import 'package:dairo_dfs_app/page/my_share/uc/UCMyShareOptionMenu.dart';
import 'package:flutter/material.dart';

/// 文件列表页面
class MySharePage extends StatefulWidget {
  const MySharePage({super.key});

  @override
  State<MySharePage> createState() => MySharePageState();
}

class MySharePageState extends State<MySharePage> {
  ///文件列表组件
  late var ucTrashList = UCMyShareList(this);

  ///操作菜单组件
  late var ucOptionMenu = UCMyShareOptionMenu(this);

  ///当前被选中的文件数量
  var selectedCount = 0;

  @override
  void initState() {
    super.initState();

    //页面加载完成之后回调事件
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //加载文件列表
      this.ucTrashList.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("回收站")),
        body: Container(
            color: context.color.primaryContainer,
            child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    this.ucTrashList, //文件列表
                    this.ucOptionMenu, //操作功能菜单
                  ],
                ))));
  }

  ///选择改变事件
  void onCheckChange(bool flag) {
    flag ? this.selectedCount++ : this.selectedCount--;
    this.ucOptionMenu.redraw();
    this.ucTrashList.redraw();
  }

  ///页面被销毁时
  @override
  dispose() {
    super.dispose();
  }
}
