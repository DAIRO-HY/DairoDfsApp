
import 'package:dairo_dfs_app/api/MyShareApi.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/uc/item/ItemLabel.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../Const.dart';
import '../../../api/model/MyShareDetailModel.dart';

///分享设置
class UCShareInfo {
  ///显示分享信息
  ///[shareId] 分享ID
  static void show(BuildContext context, int shareId) {
    MyShareApi.getDetail(id: shareId).post((data) async {
      _showDetail(context, data);
    }, context);
  }

  ///显示分享明细
  static _showDetail(BuildContext context, MyShareDetailModel data) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Const.RADIUS))),
              content: IntrinsicHeight(
                  child: Column(children: [
                Gap(10),
                Text("分享明细"),
                Gap(10),
                ItemLabel(
                  "创建日期",
                  tip: data.date!,
                ),
                ItemLabel(
                  "有效期",
                  tip: data.endDate!,
                ),
                ItemLabel(
                  "所属文件夹",
                  tip: data.folder!,
                ),
                ItemLabel(
                  "提取码",
                  tip: data.pwd!,
                ),
                Gap(20),
                Row(children: [
                  Spacer(),
                  TextButton(
                    child: context.textBody("取消"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // cancelFun();
                    },
                  ),
                  TextButton(
                    child: context.textBody("复制链接"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // okFun();
                    },
                  )
                ])
              ])));
        });
  }
}
