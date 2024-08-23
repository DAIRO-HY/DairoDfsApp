import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/Number++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';

import '../../../Const.dart';
import '../../../uc/UCImage.dart';
import '../bean/DfsFileBean.dart';
import 'UCFileItem.dart';

///列表显示视图
class UCListFileItem extends StatelessWidget {
  ///缩略图高度
  static const THUMB_SIZE = 40.0;

  ///文件列表项目共通部分
  final UCFileItem fi;

  ///文件数据
  late final DfsFileBean dfsFile = this.fi.dfsFile;

  UCListFileItem({
    super.key,
    required this.fi,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Gap(10),
        this.thumbView(context), //文件图标
        Gap(10),
        Expanded(
            child: Container(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.color.outline, width: 1))),
                child: Row(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      context.textBody(this.dfsFile.name),
                      context.textSecondarySmall("${this.dfsFile.date}  ${this.dfsFile.size.dataSize}")
                    ],
                  ),
                  Spacer(),
                  this.checkIconView(context),
                  Gap(5),
                ])))
      ],
    );
  }

  ///选择图标
  Widget checkIconView(BuildContext context) => this.fi.selectedVN.build((value) {
        if (this.fi.isSelectMode) {

          //选择模式
          return Icon(this.dfsFile.isSelected ? Icons.check_circle : Icons.circle_outlined, color: context.color.onSurface);
        }
        if (!this.dfsFile.fileFlag) {

          //这是一个文件夹的时候
          return Icon(Icons.chevron_right, color: context.color.onSurface, size: 30);
        }
        //这是一个文件的时候
        return SizedBox();
      });

  ///文件图标
  Widget thumbView(BuildContext context) {
    if (this.dfsFile.fileFlag) {
      //如果是文件
      if (this.dfsFile.thumbId != null) {
        return UCImage(this.dfsFile.thumb!, width: THUMB_SIZE, height: THUMB_SIZE, radius: Const.RADIUS, checkedDownload: false);
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
      return Icon(Icons.folder, size: THUMB_SIZE, color: Color(0xFF6FBEEA));
    }
  }
}
