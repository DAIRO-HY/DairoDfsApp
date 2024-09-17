import 'package:dairo_dfs_app/api/MyShareApi.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/uc/item/ItemLabel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Const.dart';
import '../../../api/model/MyShareDetailModel.dart';
import '../../../uc/item/ItemBase.dart';
import '../../../util/Toast.dart';
import '../../../util/shared_preferences/SettingShared.dart';

///分享设置
class UCShareDetailDialog {
  ///显示分享信息
  ///[shareId] 分享ID
  static void show(BuildContext context, int shareId) {
    MyShareApi.getDetail(id: shareId).post((data) async {
      _showDetail(context, data);
    }, context);
  }

  ///显示分享明细
  static _showDetail(BuildContext context, MyShareDetailModel model) {
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
                  tip: model.date!,
                ),
                ItemLabel(
                  "有效期",
                  tip: model.endDate!,
                ),
                ItemLabel(
                  "所属文件夹",
                  tip: model.folder!,
                ),
                ItemLabel(
                  "提取码",
                  tip: model.pwd!,
                ),
                Container(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                        height: ItemBase.HEIGHT,
                        padding: const EdgeInsets.only(right: 8),
                        decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(ItemBase.BORDER_LINE_COLOR), width: ItemBase.BORDER_LINE_WIDTH))),
                        child: Row(children: [
                          context.textBody("链接"),
                          Spacer(),
                          context.textButton("打开", onPressed: () {
                            openShareLink(context, model);
                          }),
                          Gap(10),
                          context.textButton("复制", onPressed: () {
                            copyShareLink(model);
                            Toast.show(context, "复制成功");
                          })
                        ])))
              ])));
        });
  }

  ///打开链接点击事件
  static void openShareLink(BuildContext context, MyShareDetailModel model) async {
    final Uri url = Uri.parse(SettingShared.domainNotNull + model.url!);
    if (await canLaunchUrl(url)) {
      // await launchUrl(url, mode: LaunchMode.externalApplication);
      await launchUrl(url);
    } else {
      Toast.show(context, "无法打开网址 $url");
    }
  }

  ///复制链接点击事件
  static void copyShareLink(MyShareDetailModel model) {
    var shareCopyText = "分享的文件:${model.names}\n链接: ${SettingShared.domainNotNull}${model.url}";
    if (model.pwd != "无") {
      shareCopyText += "\n提取码: ${model.pwd}";
    }
    shareCopyText += "\n点击上面的链接提取文件";
    Clipboard.setData(ClipboardData(text: shareCopyText));
  }
}
