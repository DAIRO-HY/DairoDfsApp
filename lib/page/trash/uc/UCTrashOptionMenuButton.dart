import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';

///操作菜单按钮按钮
class UCTrashOptionMenuButton extends StatelessWidget {
  ///点击回调事件
  final VoidCallback? onPressed;

  ///高度
  static const HEIGHT = 42.0;

  ///标题
  final String label;

  ///图标
  final IconData? icon;

  ///是否禁用
  final bool disabled;

  UCTrashOptionMenuButton(
    this.label, {
    super.key,
    this.icon,
    this.onPressed,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: TextButton(
            style: TextButton.styleFrom(
                minimumSize: const Size(0, 0), // 选填：设置最小尺寸
                tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 选填：紧凑的点击目标尺寸
                padding: EdgeInsets.only(left: 8), //设置没有内边距
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // 设置圆角
                )),
            onPressed: this.disabled ? null : this.onPressed,
            child: Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Column(children: [
                  Icon(this.icon, size: 18),
                  const Gap(8),
                  context.textSmall(this.label)
                ]))));
  }
}
