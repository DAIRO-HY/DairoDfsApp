import 'package:flutter/material.dart';
import '../../file/bean/DfsFileBean.dart';
import 'UCGridAlbumItem.dart';

///文件列表栏
class UCAlbumItem extends StatelessWidget {

  ///DFS文件信息
  final DfsFileBean dfsFile;

  ///DFS文件信息
  final double width;

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

  UCAlbumItem(this.dfsFile,this.width,
      {super.key, required this.isSelectMode, required this.onSelectChange, required this.onLoadSubFile, required this.onFileClick}) {
    this.selectedVN = ValueNotifier(this.dfsFile.isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
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
            child: UCGridAlbumItem(fi: this,width: this.width,));
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
