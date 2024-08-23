import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';

import '../Const.dart';

///自定义按钮
class UCButton extends StatelessWidget {
  ///按钮文本
  final String label;

  ///按钮宽度
  final double width;

  ///点击回调事件
  final VoidCallback onPressed;

  ///背景颜色
  final Color? bgColor;

  ///字体颜色
  final Color? fontColor;

  const UCButton(this.label, {super.key, this.width = 999999, required this.onPressed, this.bgColor, this.fontColor});

  @override
  Widget build(BuildContext context) {
    final bgColor = this.bgColor ?? context.color.primary;
    final fontColor = this.fontColor ?? context.color.onPrimary;
    return TextButton(
        style: TextButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // 选填：紧凑的点击目标尺寸
          padding: EdgeInsets.zero,
          backgroundColor: bgColor,
          // 设置背景颜色
          foregroundColor: fontColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Const.RADIUS), // 设置圆角
          ),
          minimumSize: Size(0, 0), // 设置宽度和高度
        ),
        onPressed: onPressed,
        child: SizedBox(height: 40, child: Center(child: context.textBody(this.label, color: fontColor))));
  }
}
