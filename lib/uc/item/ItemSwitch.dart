import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';

import 'ItemBase.dart';

///条目开关
class ItemSwitch extends ItemBase {
  ///点击回调事件
  final void Function(bool value) onChange;

  ///开关值改变监听
  final switchVN = ValueNotifier<bool>(true);

  ItemSwitch(
    super.label, {
    super.key,
    super.icon,
    bool value = true,
    required this.onChange,
  }) {
    this.switchVN.value = value;
  }

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
        onPressed: () {
          this.switchVN.value = !this.switchVN.value;
          this.onChange(this.switchVN.value);
        },
        child: Container(
            height: ItemBase.HEIGHT,
            decoration: this.isShowLine
                ? const BoxDecoration(border: Border(bottom: BorderSide(color: Color(ItemBase.BORDER_LINE_COLOR), width: ItemBase.BORDER_LINE_WIDTH)))
                : null,
            child: Row(children: [
              super.ico(context),
              Gap(this.icon == null ? 0 : 6),
              context.textBody(this.label),
              const Spacer(),
              Transform.scale(
                  scale: .8, // 调整这个值来改变Switch的大小
                  child: this.switchVN.build((value) => Switch(
                      value: value,
                      activeTrackColor: Colors.green,
                      activeColor: context.color.primary,
                      onChanged: (bool value) {
                        this.switchVN.value = value;
                        this.onChange(value);
                      })),
              )
            ])));
  }
}
