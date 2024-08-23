import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/uc/UCInput.dart';

import 'UCDialogBase.dart';

///文本输入对话框
class UCInputDialog {

  ///显示
  ///[context] 上下文
  ///[title] 标题
  ///[value] 初始值
  ///[okFun] 确认按钮回调事件
  static void show(BuildContext context, {String? title, String value = "", required void Function(String value) okFun}) {
    ///输入控制器
    final controller = TextEditingController();
    controller.text = value;
    UCDialogBase.show(context, title: title, content: UCInput(controller: controller), okFun: () {
      final value = controller.text;
      okFun(value);
    }, cancelFun: () {});
  }
}
