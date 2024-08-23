import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/List++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';

import 'ItemBase.dart';

///条目列表选择
class ItemSelect extends ItemBase {
  ///点击回调事件
  final void Function(Object value) onChange;

  ///选中序号改变监听
  late final ValueNotifier<String> selectTextNotifier;

  ///选择项目列表
  final List<ItemSelectOption> options;

  ///当前选中的序号
  var selectedIndex = -1;

  final Object value;

  ItemSelect(
    super.label, {
    super.key,
    super.icon,
    super.tip = "",
    required this.value,
    required this.options,
    required this.onChange,
  }) {
    this.selectedIndex = this.options.findIndex((it) => it.value == this.value);
    if (this.selectedIndex == -1) {
      this.selectTextNotifier = ValueNotifier("");
    } else {
      this.selectTextNotifier = ValueNotifier(this.options[this.selectedIndex].text);
    }
    // final selected = this.options.find((it) => it.value == this.value);
    // if (selected == null) {
    //   this.selectTextNotifier = ValueNotifier("");
    // } else {
    //   this.selectTextNotifier = ValueNotifier(selected.text);
    // }
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
          this.onItemClick(context);
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
              Spacer(),
              this.selectTextNotifier.build((value) => context.textBody(value, color: context.color.secondary)),
              Icon(
                Icons.chevron_right,
                color: context.color.secondary,
              )
            ])));
  }

  onItemClick(BuildContext context) {
    Picker picker = Picker(
        adapter: PickerDataAdapter<String>(pickerData: options.map((it) => it.text).toList()),
        //changeToFirst: false,
        hideHeader: false,
        backgroundColor: context.color.primaryContainer,
        headerColor: context.color.primaryContainer,

        //头部底边线
        headerDecoration: BoxDecoration(border: Border(bottom: BorderSide(color:context.color.outline, width: 0.5))),
        selecteds: [this.selectedIndex],
        //textAlign: TextAlign.left,
        textStyle: TextStyle(color: context.color.onSurface),
        selectedTextStyle: TextStyle(color: context.color.onSurface),
        //columnPadding: const EdgeInsets.all(0.0),
        cancelText: "取消",
        cancelTextStyle: TextStyle(color: context.color.onSurface),
        confirmText: "确定",
        confirmTextStyle: TextStyle(color: context.color.onSurface),
        onConfirm: (Picker picker, List value) {
          //当前选中的序号
          this.selectedIndex = value[0];

          //更新显示值
          this.selectTextNotifier.value = this.options[this.selectedIndex].text;

          //当前选中的值
          final selectValue = this.options[value[0]].value;
          this.onChange(selectValue);
        });
    picker.showModal(context, builder: (context, view) {
      return Material(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          child: Container(
            padding: const EdgeInsets.only(top: 4),
            child: view,
          ));
    });
  }
}

class ItemSelectOption {
  final String text;
  final Object value;

  ItemSelectOption(this.text, this.value);
}
