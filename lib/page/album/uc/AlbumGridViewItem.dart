import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import 'package:flutter/material.dart';
import '../../../Const.dart';
import '../../../uc/UCImage.dart';
import '../vm/AlbumVM.dart';

///文件列表栏
class AlbumGridViewItem extends StatelessWidget {
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

  AlbumGridViewItem(this.albumVM, this.width,
      {super.key,
      required this.isSelectMode,
      required this.onSelectChange,
      required this.onClick}) {
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
        child: Column(children: [
          Stack(alignment: AlignmentDirectional.center, children: [
            this.thumbView(context), //文件图标
            this.checkIconView(context),
            this.durationView(context)
          ])
        ]));
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

  ///选择图标
  Widget checkIconView(BuildContext context) => Positioned(
      right: 2,
      bottom: 2,
      child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: context.color.surface.withOpacity(0.8),
                spreadRadius: 1,
                blurRadius: 30,
                // offset: Offset(2, 2),
              ),
            ],
          ),
          child: this.selectedVN.build((value) {
            if (this.isSelectMode) {
              //选择模式
              Icon icon = Icon(
                  this.albumVM.isSelected ? Icons.check_circle : null,
                  color: context.color.onSurface);
              return icon;
            }
            return SizedBox();
          })));

  ///视频时间
  Widget durationView(BuildContext context) => Positioned(
      right: 8,
      bottom: 8,
      child: this.albumVM.duration == null
          ? SizedBox()
          : Text(this.albumVM.duration!,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Const.TEXT_SMALL,
                  shadows: const [
                    Shadow(
                        color: Colors.black, //阴影颜色
                        offset: Offset(1, 1), //偏移量
                        blurRadius: 7 //模糊半径
                        )
                  ])));

  ///文件图标
  Widget thumbView(BuildContext context) {
    if (this.albumVM.thumb.isNotEmpty) {
      return Container(
          padding: EdgeInsets.all(0),
          width: this.width,
          height: this.width,
          child: UCImage(this.albumVM.thumb,
              width: 0, height: 0, radius: 0, checkedDownload: false));
    } else {
      return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: context.color.onSurface.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: Icon(Icons.insert_drive_file,
              size: this.width, color: Colors.white));
    }
  }
}
