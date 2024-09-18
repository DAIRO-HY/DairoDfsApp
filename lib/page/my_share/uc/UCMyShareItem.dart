import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import '../../../Const.dart';
import '../../../uc/UCImage.dart';
import '../bean/MyShareBean.dart';
import 'UCShareDetailDialog.dart';

///文件列表栏
class UCMyShareItem extends StatelessWidget {
  ///DFS文件信息
  final MyShareBean myShareFile;

  ///是否被选中图标更新
  late final ValueNotifier checkedVN;

  ///选择状态发生改变事件
  final void Function(bool flag) onCheckChange;

  ///缩略图高度
  static const THUMB_SIZE = 40.0;

  UCMyShareItem(this.myShareFile, {super.key, required this.onCheckChange}) {
    this.checkedVN = ValueNotifier(this.myShareFile.isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // 选填：紧凑的点击目标尺寸
          padding: EdgeInsets.only(left: 8, right: 0),
          //backgroundColor: context.color.primary,
          // 设置背景颜色
          //foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // 设置圆角
          ),
          minimumSize: Size(0, 0), // 设置宽度和高度
        ),
        onPressed: () {
          this.onItemClick(context);
        },
        child: Row(
          children: [
            this.thumbView(context), //缩略图
            const Gap(10),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.only(top: 0, bottom: 0),
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0x11000000), width: 1))),
                    child: Row(children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(8),
                          context.textBody(this.myShareFile.name),
                          context.textSecondarySmall("${this.myShareFile.date}  ${this.myShareFile.endDate}"),
                          Gap(8),
                        ],
                      )),
                      this.checkIconView(context)
                    ])))
          ],
        ));
  }

  ///文件图标
  Widget thumbView(BuildContext context) {
    if (this.myShareFile.thumb != null) {
      return UCImage(this.myShareFile.thumb!, width: THUMB_SIZE, height: THUMB_SIZE, radius: Const.RADIUS, checkedDownload: false);
    }

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
        child: Icon(this.myShareFile.multipleFlag ? Icons.file_copy_sharp : Icons.insert_drive_file, size: THUMB_SIZE, color: Colors.white));
  }

  ///选择图标
  Widget checkIconView(BuildContext context) => TextButton(
      onPressed: this.onCheckedChangeClick,
      style: TextButton.styleFrom(
        overlayColor: Colors.transparent,
        minimumSize: const Size(50, 60),
        // 选填：设置最小尺寸
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // 选填：紧凑的点击目标尺寸
        padding: EdgeInsets.zero,
        //设置没有内边距
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), // 设置圆角
        ),
        backgroundColor: Colors.transparent,
      ),
      child: this.checkedVN.build(
          (value) => Icon(this.myShareFile.isSelected ? Icons.check_circle : Icons.circle_outlined, size: 24, color: context.color.onSurface)));

  ///分享点击事件
  void onItemClick(BuildContext context) {
    UCShareDetailDialog.show(context, this.myShareFile.id);
  }

  ///点击选中改变事件
  void onCheckedChangeClick() {
    this.myShareFile.isSelected = !this.myShareFile.isSelected;
    this.checkedVN.value = this.myShareFile.isSelected;
    this.onCheckChange(this.myShareFile.isSelected);
  }

  ///选择文件点击事件
  void onCheckedClick() {
    this.myShareFile.isSelected = true;
    this.onCheckChange(true);
  }
}
