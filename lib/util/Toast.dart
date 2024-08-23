import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';

///临时提示框
class Toast {
  ///显示消息
  static show(BuildContext? context, String msg) {
    if(context == null) {
      return;
    }
    Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: context.color.onSurface,
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.info_outlined, color: context.color.surface),
          Gap(12),
          Text(msg, style: TextStyle(color: context.color.surface)),
        ]));

    final fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
}
