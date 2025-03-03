import 'package:flutter/material.dart';
import '../vm/AlbumVM.dart';
import 'UCGridAlbumItem.dart';

///文件列表栏
class UCAlbumItem extends StatelessWidget {
  ///相册信息
  final AlbumVM albumVM;

  ///DFS文件信息
  final double width;

  ///是否选择模式
  final bool isSelectMode;

  ///是否被选中图标更新
  late final ValueNotifier selectedVN;

  ///选择状态发生改变事件
  final void Function(bool flag) onSelectChange;

  ///点击事件
  final void Function(AlbumVM) onClick;

  UCAlbumItem(this.albumVM, this.width,
      {super.key, required this.isSelectMode, required this.onSelectChange, required this.onClick}) {
    this.selectedVN = ValueNotifier(this.albumVM.isSelected);
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
        child: UCGridAlbumItem(
          fi: this,
          width: this.width,
        ));
  }

  ///文件条目点击事件
  void onItemClick() {
    if (this.isSelectMode) {
      //选择模式时
      this._onSelectedChangeClick();
      return;
    }
    this.onClick(this.albumVM);
  }

  ///点击选中改变事件
  void _onSelectedChangeClick() {
    this.albumVM.isSelected = !this.albumVM.isSelected;
    this.selectedVN.value = this.albumVM.isSelected;
    this.onSelectChange(this.albumVM.isSelected);
  }

  ///选择文件点击事件
  void onSelectedClick() {
    this.albumVM.isSelected = true;
    this.onSelectChange(true);
  }
}
