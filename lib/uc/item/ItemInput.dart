import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';

import '../../Const.dart';
import 'ItemBase.dart';

///条目输入框
class ItemInput extends ItemBase {

  ///输入控制器
  final TextEditingController? controller;

  ///密码类型
  bool password;

  ItemInput(super.label, {super.key, super.icon, this.password = false, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 8),
        child: Container(
            height: ItemBase.HEIGHT,
            padding: const EdgeInsets.only(right: 8),
            decoration: this.isShowLine
                ? const BoxDecoration(border: Border(bottom: BorderSide(color: Color(ItemBase.BORDER_LINE_COLOR), width: ItemBase.BORDER_LINE_WIDTH)))
                : null,
            child: Row(children: [
              super.ico(context),
              Gap(this.icon == null ? 0 : 6),
              context.textBody(this.label),
              Gap(10),
              Expanded(
                  child: TextField(
                textAlign: TextAlign.right,
                obscureText: this.password,
                controller: this.controller,
                cursorColor: context.color.onSurface, //光标颜色
                style: const TextStyle(fontSize: Const.TEXT),
                decoration: InputDecoration(
                  // labelText: "点击输入内容",
                  labelStyle: const TextStyle(fontSize: Const.TEXT, color: Colors.grey),
                  // contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,

                  // OutlineInputBorder(
                  //   borderSide: BorderSide(color: Colors.transparent, width: 0),
                  // ),
                ),
                onChanged: (value) {
                },
              ))
            ])));
  }
}
