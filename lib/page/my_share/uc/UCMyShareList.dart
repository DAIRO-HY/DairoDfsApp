import 'package:dairo_dfs_app/api/MyShareApi.dart';
import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/api/TrashApi.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';

import '../MySharePage.dart';
import '../bean/MyShareBean.dart';
import 'UCMyShareItem.dart';


///文件列表组件
class UCMyShareList extends StatelessWidget {
  ///文件列表改变监听器
  final fileListFlagVN = ValueNotifier(0);

  ///文件页面状态对象
  final MySharePageState mySharePageState;

  List<MyShareBean> dfsFileList = [];

  late BuildContext _context;

  UCMyShareList(this.mySharePageState, {super.key});

  @override
  Widget build(BuildContext context) {
    this._context = context;
    return Expanded(
        child: this.fileListFlagVN.build((value) => ListView.builder(
                itemCount: this.dfsFileList.length,
                itemBuilder: (context, index) {
                  final dfsFile = this.dfsFileList[index];

                  //文件列表条目
                  return UCMyShareItem(
                    dfsFile,
                    onCheckChange: this.mySharePageState.onCheckChange,
                  );
                })));
  }

  ///当前选中的路径列表
  List<int> get selectedPaths => this.dfsFileList.where((it) => it.isSelected).map((it) => it.id).toList();

  ///获取文件列表
  void loadData() {
    MyShareApi.getList().post((data) async{
      this.mySharePageState.selectedCount = 0;
      this.dfsFileList = data.map((it) => MyShareBean(it)).toList();

      //重回文件页面
      this.redraw();
      this.mySharePageState.ucOptionMenu.redraw();
    }, this._context);
  }

  ///重绘页面
  void redraw() {
    this.fileListFlagVN.value = this.fileListFlagVN.value++;
  }
}
