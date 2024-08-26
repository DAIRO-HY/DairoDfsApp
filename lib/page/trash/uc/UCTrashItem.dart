import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import '../bean/TrashBean.dart';

///文件列表栏
class UCTrashItem extends StatelessWidget {
  ///DFS文件信息
  final TrashBean dfsFile;

  ///是否被选中图标更新
  late final ValueNotifier checkedVN;

  ///选择状态发生改变事件
  final void Function(bool flag) onCheckChange;

  ///缩略图高度
  static const THUMB_SIZE = 40.0;

  UCTrashItem(this.dfsFile, {super.key, required this.onCheckChange}) {
    this.checkedVN = ValueNotifier(this.dfsFile.isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // 选填：紧凑的点击目标尺寸
          padding: EdgeInsets.only(left: 8, right: 8),
          //backgroundColor: context.color.primary,
          // 设置背景颜色
          //foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // 设置圆角
          ),
          minimumSize: Size(0, 0), // 设置宽度和高度
        ),
        onPressed: this.onCheckedChangeClick,
        child: Row(
          children: [
            this.thumbView(context), //缩略图
            const Gap(10),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0x11000000), width: 1))),
                    child: Row(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          context.textBody(this.dfsFile.name),
                          context.textSecondarySmall("${this.dfsFile.date}  ${this.dfsFile.size}"),
                        ],
                      ),
                      Spacer(),
                      this.checkIconView(context),
                    ])))
          ],
        ));
  }

  ///文件图标
  Widget thumbView(BuildContext context) {
    // if (this.dfsFile.fileFlag) {
    //   //如果是文件
    //   if (this.dfsFile.thumbId != null) {
    //     return UCImage(this.dfsFile.thumb!, width: THUMB_SIZE, height: THUMB_SIZE, radius: Const.RADIUS, checkedDownload: false);
    //   } else {
    //     return Container(
    //         decoration: BoxDecoration(
    //           boxShadow: [
    //             BoxShadow(
    //               color: context.color.onSurface.withOpacity(0.1),
    //               spreadRadius: 1,
    //               blurRadius: 10,
    //               // offset: Offset(2, 2),
    //             ),
    //           ],
    //         ),
    //         child: Icon(Icons.insert_drive_file, size: THUMB_SIZE, color: Colors.white));
    //   }
    // } else {
    //   //如果是文件夹
    //   return Icon(Icons.folder, size: THUMB_SIZE, color: Color(0xFF6FBEEA));
    // }
    if (this.dfsFile.fileFlag) {
      //如果是文件
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
    } else {
      //如果是文件夹
      return Icon(Icons.folder, size: THUMB_SIZE, color: Color(0xFF6FBEEA));
    }
  }

  ///选择图标
  Widget checkIconView(BuildContext context) => this
      .checkedVN
      .build((value) => Icon(this.dfsFile.isSelected ? Icons.check_circle : Icons.circle_outlined, size: 24, color: context.color.onSurface));

  ///点击选中改变事件
  void onCheckedChangeClick() {
    this.dfsFile.isSelected = !this.dfsFile.isSelected;
    this.checkedVN.value = this.dfsFile.isSelected;
    this.onCheckChange(this.dfsFile.isSelected);
  }

  ///选择文件点击事件
  void onCheckedClick() {
    this.dfsFile.isSelected = true;
    this.onCheckChange(true);
  }
}
