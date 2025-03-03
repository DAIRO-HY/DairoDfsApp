import 'package:dairo_dfs_app/page/album/vm/AlbumVM.dart';
import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';

import '../../../uc/UCImage.dart';
import 'UCAlbumItem.dart';

///表格显示视图
class UCGridAlbumItem extends StatelessWidget {
  ///缩略图高度
  static const THUMB_SIZE = 90.0;

  ///DFS文件信息
  final double width;

  ///文件列表项目共通部分
  final UCAlbumItem fi;

  ///文件数据
  late final AlbumVM dfsFile = this.fi.albumVM;

  UCGridAlbumItem({
    super.key,
    required this.fi,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    // return Container(color: Colors.red);
    return Column(
      children: [
        Stack(alignment: AlignmentDirectional.center, children: [
          this.thumbView(context), //文件图标
          this.checkIconView(context)
        ])
      ]);
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
          child: this.fi.selectedVN.build((value) {
            if (this.fi.isSelectMode) {
              //选择模式
              Icon icon = Icon(this.dfsFile.isSelected ? Icons.check_circle : null, color: context.color.onSurface);
              return icon;
            }
            return SizedBox();
          })));

  ///文件图标
  Widget thumbView(BuildContext context) {
    if (this.dfsFile.fileFlag) {
      //如果是文件
      if (this.dfsFile.thumb != null) {
        return Container(
            padding: EdgeInsets.all(0),
            width: this.width,
            height: this.width,
            child: UCImage(this.dfsFile.thumb!, width: 0, height: 0, radius: 0, checkedDownload: false));
      } else {
        return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: context.color.onSurface.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  // offset: Offset(2, 2),
                ),
              ],
            ),
            child: Icon(Icons.insert_drive_file, size: this.width, color: Colors.white));
      }
    } else {
      //如果是文件夹
      return Icon(Icons.folder, size: UCGridAlbumItem.THUMB_SIZE, color: Color(0xFF6FBEEA));
    }
  }
}
