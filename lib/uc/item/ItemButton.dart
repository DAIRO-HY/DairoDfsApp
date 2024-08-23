import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';

import 'ItemBase.dart';

///条目按钮
class ItemButton extends ItemBase {
  ///点击回调事件
  final VoidCallback? onPressed;

  ItemButton(
    super.label, {
    super.key,
    super.icon,
    super.tip = "",
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            minimumSize: const Size(0, 0), // 选填：设置最小尺寸
            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 选填：紧凑的点击目标尺寸
            padding: EdgeInsets.only(left: 8), //设置没有内边距
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0), // 设置圆角
            )),
        onPressed: this.onPressed,
        child: Container(
            height: ItemBase.HEIGHT,
            decoration: this.isShowLine ? const BoxDecoration(border: Border(bottom: BorderSide(color: Color(ItemBase.BORDER_LINE_COLOR), width: ItemBase.BORDER_LINE_WIDTH))) : null,
            child: Row(children: [
              super.ico(context),
              Gap(this.icon == null ? 0 : 6),
              context.textBody(this.label),
              Spacer(),
              context.textBody(this.tip, color: context.color.secondary),
              Icon(
                Icons.chevron_right,
                color: context.color.secondary,
              )
            ])));
  }
}
