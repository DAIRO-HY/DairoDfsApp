import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/code/FileViewType.dart';
import '../bean/DfsFileBean.dart';
import 'UCFileOptionMenu.dart';
import 'UCGridFileItem.dart';
import 'UCListFileItem.dart';

///文件列表栏
class UCFileItem extends StatelessWidget {
  ///DFS文件信息
  final DfsFileBean dfsFile;

  ///列表或者表格显示类型
  final int viewType;

  ///是否选择模式
  final bool isSelectMode;

  ///是否被选中图标更新
  late final ValueNotifier selectedVN;

  ///选择状态发生改变事件
  final void Function(bool flag) onSelectChange;

  ///加载子文件回调
  final void Function(String path) onLoadSubFile;

  ///文件点击事件
  final void Function(DfsFileBean dfsFile) onFileClick;

  UCFileItem(this.dfsFile, this.viewType,
      {super.key, required this.isSelectMode, required this.onSelectChange, required this.onLoadSubFile, required this.onFileClick}) {
    this.selectedVN = ValueNotifier(this.dfsFile.isSelected);
  }

  @override
  Widget build(BuildContext context) {
    double opacity = 1;
    if (UCFileOptionMenu.clipboardType == 1) {
      //剪切板有数据时,则将被剪切的文件标记为半透明
      if (UCFileOptionMenu.clipboardPaths!.contains(this.dfsFile.path)) {
        opacity = 0.5;
      }
    }
    return Opacity(
        opacity: opacity,
        child: TextButton(
            style: TextButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              // 选填：紧凑的点击目标尺寸
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0), // 设置圆角
              ),
              minimumSize: Size(0, 0), // 设置宽度和高度
            ),
            onPressed: onItemClick,
            child: this.viewType == FileViewType.LIST ? UCListFileItem(fi: this) : UCGridFileItem(fi: this)));
  }

  ///文件条目点击事件
  void onItemClick() {
    if (this.isSelectMode) {
      this._onSelectedChangeClick();
      return;
    }
    if (this.dfsFile.fileFlag) {
      //这是一个文件的时候
      this.onFileClick(this.dfsFile);
    } else {
      //打开文件夹
      this.onLoadSubFile(this.dfsFile.path);
    }
  }

  ///点击选中改变事件
  void _onSelectedChangeClick() {
    this.dfsFile.isSelected = !this.dfsFile.isSelected;
    this.selectedVN.value = this.dfsFile.isSelected;
    this.onSelectChange(this.dfsFile.isSelected);
  }

  ///选择文件点击事件
  void onSelectedClick() {
    this.dfsFile.isSelected = true;
    this.onSelectChange(true);
  }
}
