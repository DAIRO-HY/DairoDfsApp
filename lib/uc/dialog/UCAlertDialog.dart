import 'package:flutter/material.dart';

import 'UCDialogBase.dart';

///Alert对话框
class UCAlertDialog {
  ///显示
  ///[context] 上下文
  ///[title] 标题
  ///[msg] 提示消息
  ///[okFun] 确认按钮回调事件
  static void show(BuildContext context, {String? title, required String msg, required VoidCallback? okFun, VoidCallback? cancelFun}) {
    UCDialogBase.show(context, title: title, content: Text(msg), okFun: () {
      if (okFun != null) {
        okFun();
      }
    }, cancelFun: cancelFun);
  }
}
