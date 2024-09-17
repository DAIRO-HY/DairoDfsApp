import 'dart:math';

import 'package:dairo_dfs_app/api/FilesApi.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/DateTime++.dart';
import 'package:dairo_dfs_app/extension/String++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import 'package:dairo_dfs_app/uc/item/ItemButton.dart';
import 'package:dairo_dfs_app/uc/item/ItemSelect.dart';
import 'package:dairo_dfs_app/uc/item/ItemSwitch.dart';
import 'package:dairo_dfs_app/util/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';
import 'package:gap/gap.dart';

import '../../../Const.dart';
import '../../../uc/dialog/UCDatePickerDialog.dart';
import '../../../uc/item/ItemInput.dart';
import '../../my_share/uc/UCShareDetailDialog.dart';

///分享设置
class UCShare {
  static void show(BuildContext context, List<String> paths) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //密码输入
          final pwdCtl = TextEditingController(text: _makePwd());

          //密码分享开关
          final pwdShareVN = ValueNotifier(true);

          //结束时间选择
          final endDateVN = ValueNotifier<DateTime?>(null);

          //分享有效期天数
          final shareDaysVN = ValueNotifier(3);
          return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Const.RADIUS))),
              content: IntrinsicHeight(
                  child: Column(children: [
                Gap(10),
                Text("创建分享链接"),
                Gap(10),
                ItemSelect(
                  "有效期",
                  options: [
                    ItemSelectOption("3天", 3),
                    ItemSelectOption("7天", 7),
                    ItemSelectOption("30天", 30),
                    ItemSelectOption("永久", 0),
                    ItemSelectOption("选择结束日期", -1),
                  ],
                  value: shareDaysVN.value,
                  onChange: (value) {
                    if (value == -1) {
                      endDateVN.value = DateTime.now();
                    }
                    shareDaysVN.value = value as int;
                  },
                ),
                shareDaysVN.build((shareDays) => Visibility(
                    visible: shareDays == -1,
                    child: endDateVN.build((value) {
                      return ItemButton("截止日期", tip: value.format(), onPressed: () {
                        UCDatePickerDialog.show(context, title: "请选择结束时间", type: PickerDateTimeType.kYMDHMS, okFun: (value) {
                          endDateVN.value = value;
                        });
                      });
                    }))),
                ItemSwitch(
                  "加密分享",
                  onChange: (value) {
                    pwdShareVN.value = value;
                    if(value){
                      pwdCtl.text = _makePwd();
                    }
                  },
                ),
                pwdShareVN.build((value) => Visibility(visible: value, child: ItemInput("密码", controller: pwdCtl))),
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
                    child: context.textBody("确认"),
                    onPressed: () {
                      //结束时间戳
                      var endDateTime = 0;
                      if (shareDaysVN.value == -1) {
                        //自定义结束日期
                        if (endDateVN.value == null) {
                          Toast.show(context, "请选择结束日期");
                          return;
                        }
                        endDateTime = endDateVN.value!.millisecondsSinceEpoch;
                      } else if (shareDaysVN.value == 0) {
                        //0代表永久有效
                        endDateTime = 0;
                      } else {
                        endDateTime = DateTime.now().millisecondsSinceEpoch + shareDaysVN.value * 24 * 60 * 60 * 1000;
                      }

                      //设置的密码
                      String? pwd;
                      if (pwdShareVN.value) {
                        //密码分享
                        pwd = pwdCtl.text;
                        if (pwd.isEmpty) {
                          Toast.show(context, "请设置一个密码");
                          return;
                        }
                      }

                      final folder = paths[0].fileParent;
                      final names = paths.map((it) => it.fileName).toList();
                      FilesApi.share(endDateTime: endDateTime, pwd: pwd, folder: folder, names: names).post((shareId) async {
                        Navigator.of(context).pop();
                        UCShareDetailDialog.show(context, shareId);
                      }, context);
                      // Navigator.of(context).pop();
                      // okFun();
                    },
                  )
                ])
              ])));
        });
  }

  ///生成一个密码
  static String _makePwd() {
    const characters = 'ABCDEFGHJKLMNOPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz0123456789';
    final random = Random();

    //随机生成4个字符的密码
    final pwd = String.fromCharCodes(Iterable.generate(4, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
    return pwd;
  }
}
