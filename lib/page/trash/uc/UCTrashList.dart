import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/api/TrashApi.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';

import '../../../Const.dart';
import '../TrashPage.dart';
import '../bean/TrashBean.dart';
import 'UCTrashItem.dart';

///文件列表组件
class UCTrashList extends StatelessWidget {
  ///文件列表改变监听器
  final fileListFlagVN = ValueNotifier(0);

  ///文件页面状态对象
  final TrashPageState trashPageState;

  List<TrashBean> dfsFileList = [];

  late BuildContext _context;

  UCTrashList(this.trashPageState, {super.key});

  @override
  Widget build(BuildContext context) {
    this._context = context;
    return Expanded(
        child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: context.color.primaryContainer, borderRadius: BorderRadius.circular(Const.RADIUS)),
            child: this.fileListFlagVN.build((value) => ListView.builder(
                itemCount: this.dfsFileList.length,
                itemBuilder: (context, index) {
                  final dfsFile = this.dfsFileList[index];

                  //文件列表条目
                  return UCTrashItem(
                    dfsFile,
                    onCheckChange: this.trashPageState.onCheckChange,
                  );
                }))));
  }

  ///当前选中的路径列表
  List<int> get selectedPaths => this.dfsFileList.where((it) => it.isSelected).map((it) => it.id).toList();

  ///获取文件列表
  void loadData() {
    TrashApi.getList().post((data) async{
      this.trashPageState.selectedCount = 0;
      this.dfsFileList = data.map((it) => TrashBean(it)).toList();

      //重回文件页面
      this.redraw();
      this.trashPageState.ucOptionMenu.redraw();
    }, this._context);
  }

  ///重绘页面
  void redraw() {
    this.fileListFlagVN.value = this.fileListFlagVN.value++;
  }
}
