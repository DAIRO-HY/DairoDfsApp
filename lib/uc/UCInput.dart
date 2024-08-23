import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';

import '../Const.dart';

///文本输入框
class UCInput extends StatelessWidget {
  ///输入控制器
  final TextEditingController? controller;

  ///提示内容
  final String? hint;

  ///提示内容
  final String? error;

  ///密码类型
  bool password;

  UCInput({super.key, this.password = false, this.hint, this.controller, this.error});

  @override
  Widget build(BuildContext context) {
    //默认状态边框颜色
    final enabledBorderColor = this.error == null ? Colors.grey : Colors.red;

    //焦点状态边框颜色
    final focusBorderColor = this.error == null ? context.color.onSurface : Colors.red;

    return Column(children: [
      SizedBox(
        height: 40,
        child: TextField(
          obscureText: password,
          controller: controller,
          style: const TextStyle(fontSize: Const.TEXT),
          decoration: InputDecoration(
            labelText: hint,
            labelStyle: const TextStyle(fontSize: Const.TEXT, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            // 调整内边距
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Const.RADIUS), // 设置圆角
                borderSide: BorderSide(color: enabledBorderColor, width: 1)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Const.RADIUS), // 设置圆角
              borderSide: BorderSide(color: focusBorderColor, width: 1),
            ),
          ),
          // onChanged: (value) {
          // },
        ),
      ),
    Align(alignment: Alignment.centerLeft, child: context.textSmall(this.error, color: context.color.error)),
    ]);
  }
}
