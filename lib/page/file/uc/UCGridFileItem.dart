import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/Number++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';

import '../../../Const.dart';
import '../../../uc/UCImage.dart';
import '../bean/DfsFileBean.dart';
import 'UCFileItem.dart';

///表格显示视图
class UCGridFileItem extends StatelessWidget {
  ///缩略图高度
  static const THUMB_SIZE = 90.0;

  ///文件列表项目共通部分
  final UCFileItem fi;

  ///文件数据
  late final DfsFileBean dfsFile = this.fi.dfsFile;

  UCGridFileItem({
    super.key,
    required this.fi,
  });

  @override
  Widget build(BuildContext context) {
    // return Container(color: Colors.red);
    return Column(
      children: [
        Gap(10),
        Stack(alignment: AlignmentDirectional.center, children: [
          this.thumbView(context), //文件图标
          this.checkIconView(context)
        ]),
        Center(child: context.textBody(this.dfsFile.name)),
      ],
    );
  }

  ///选择图标
  Widget checkIconView(BuildContext context) => Center(
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
              Icon icon = Icon(this.dfsFile.isSelected ? Icons.check_circle : Icons.circle_outlined, color: context.color.onSurface);
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
            padding: EdgeInsets.all(8),
            width: UCGridFileItem.THUMB_SIZE,
            height: UCGridFileItem.THUMB_SIZE,
            child: UCImage(this.dfsFile.thumb!, width: 0, height: 0, radius: Const.RADIUS, checkedDownload: false));
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
            child: Icon(Icons.insert_drive_file, size: THUMB_SIZE, color: Colors.white));
      }
    } else {
      //如果是文件夹
      return Icon(Icons.folder, size: UCGridFileItem.THUMB_SIZE, color: Color(0xFF6FBEEA));
    }
  }
}
