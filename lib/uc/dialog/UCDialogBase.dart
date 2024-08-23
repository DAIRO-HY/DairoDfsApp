import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';

import '../../Const.dart';

class UCDialogBase {
  static void show(BuildContext context, {String? title, required Widget content, VoidCallback? okFun, VoidCallback? cancelFun}) {
    final actions = <Widget>[];
    if (okFun != null) {
      actions.add(TextButton(
        child: context.textBody("确认"),
        onPressed: () {
          Navigator.of(context).pop();
          okFun();
        },
      ));
    }
    if (cancelFun != null) {
      actions.add(TextButton(
        child: context.textBody("取消"),
        onPressed: () {
          Navigator.of(context).pop();
          cancelFun();
        },
      ));
    }
    final alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Const.RADIUS),
      ),
      title: title == null ? null : Text(title),
      content: IntrinsicHeight(child: content),
      actions: actions,
    );
    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }
}
