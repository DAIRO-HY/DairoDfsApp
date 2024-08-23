import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';

///加载等待框
class WaitDialog {
  ///显示等待加载框
  static show(BuildContext? context) {
    if (context == null) {
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: false, //禁止区域外点击关闭
        builder: (_) => Center(
                child: SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(strokeWidth: 2,color: context.color.onSurface)
            )));
  }

  ///隐藏等待加载框
  static hide(BuildContext? context) {
    if (context == null) {
      return;
    }
    Navigator.of(context).pop();
  }
}
