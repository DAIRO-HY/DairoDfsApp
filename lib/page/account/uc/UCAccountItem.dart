import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';

import '../../../Const.dart';
import '../../../bean/AccountInfo.dart';

///条目开关
class UCAccountItem extends StatelessWidget {
  ///底边线颜色
  static const BORDER_LINE_COLOR = 0x22000000;

  ///底边线宽度
  static const BORDER_LINE_WIDTH = .7;

  ///高度
  static const HEIGHT = 50.0;

  ///是否显示底边线
  var isShowLine = true;

  ///选择回调事件
  final void Function(AccountInfo account) onSelect;

  ///删除回调事件
  final void Function(AccountInfo account) onDelete;

  ///登录信息
  final AccountInfo account;

  UCAccountItem(
    this.account, {
    super.key,
    required this.onSelect,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      TextButton(
          style: TextButton.styleFrom(
              minimumSize: const Size(0, 0), // 选填：设置最小尺寸
              tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 选填：紧凑的点击目标尺寸
              padding: EdgeInsets.zero, //设置没有内边距
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Const.RADIUS), // 设置圆角
              )),
          onPressed: () {
            this.onDelete(this.account);
          },
          child: SizedBox(width: UCAccountItem.HEIGHT, height: UCAccountItem.HEIGHT, child: Icon(Icons.remove_circle, color: context.color.error))),
      Expanded(
          child: TextButton(
              style: TextButton.styleFrom(
                  minimumSize: const Size(0, 0), // 选填：设置最小尺寸
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 选填：紧凑的点击目标尺寸
                  padding: EdgeInsets.zero, //设置没有内边距
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), // 设置圆角
                  )),
              onPressed: this.account.isLogining
                  ? null
                  : () {
                      this.onSelect(this.account);
                    },
              child: Container(
                  height: UCAccountItem.HEIGHT,
                  decoration: this.isShowLine
                      ? const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(UCAccountItem.BORDER_LINE_COLOR), width: UCAccountItem.BORDER_LINE_WIDTH)))
                      : null,
                  child: Row(children: [
                    Gap(3),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(child: Align(alignment: Alignment.bottomLeft, child: context.textBody(this.account.name))),
                      Expanded(child: Align(alignment: Alignment.topLeft, child: context.textSecondarySmall(this.account.domain))),
                    ]),
                    const Spacer(),
                    Icon(Icons.check, color: this.account.isLogining ? context.color.onSurface : context.color.surface),
                    Gap(10)
                  ]))))
    ]);
  }

  UCAccountItem hideLine() {
    this.isShowLine = false;
    return this;
  }
}
