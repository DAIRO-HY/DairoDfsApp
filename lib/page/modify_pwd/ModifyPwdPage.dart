import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/api/ModifyApi.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import 'package:dairo_dfs_app/page/login/LoginPage.dart';
import 'package:dairo_dfs_app/util/shared_preferences/SettingShared.dart';
import 'package:gap/gap.dart';

import '../../Const.dart';
import '../../uc/UCButton.dart';
import '../../uc/UCInput.dart';

/// 修改密码页面
class ModifyPwdPage extends StatefulWidget {
  const ModifyPwdPage({super.key});

  @override
  State<ModifyPwdPage> createState() => _ModifyPwdPageState();
}

class _ModifyPwdPageState extends State<ModifyPwdPage> {
  ///表单验证失败信息
  final fieldErrorValueNotify = ValueNotifier<Map<String, dynamic>?>(null);

  ///旧密码密码输入控制器
  var oldPwdController = TextEditingController(text: "");

  ///新密码输入控制器
  var pwdController = TextEditingController(text: "");

  ///确认新密码输入控制器
  var repwdController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("修改密码")),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [const Color(0xff613a46), context.color.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
            child: Center(
                child: Column(children: [
              Spacer(),
              ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.asset("assets/images/logo_rect_128.png", width: 80, height: 80)),
              Gap(20),
              Container(
                  width: 320,
                  decoration: BoxDecoration(
                    color: context.color.primaryContainer, // 内层背景色
                    borderRadius: BorderRadius.circular(Const.RADIUS), // 内层圆角
                  ),
                  padding: const EdgeInsets.all(18),
                  // 外层内边距
                  child: this.fieldErrorValueNotify.build((value) => IntrinsicHeight(
                          child: Column(
                        children: [
                          UCInput(
                              hint: "旧密码",
                              controller: oldPwdController,
                              password: true,
                              error: this.fieldErrorValueNotify.value?["oldPwd"]?.join(";")),
                          const SizedBox(height: 15),
                          UCInput(hint: "新密码", controller: pwdController, password: true, error: this.fieldErrorValueNotify.value?["pwd"]?.join(";")),
                          const SizedBox(height: 15),
                          UCInput(
                              hint: "确认新密码",
                              controller: repwdController,
                              password: true,
                              error: this.fieldErrorValueNotify.value?["repwd"]?.join(";")),
                          const SizedBox(height: 30),
                          UCButton("修改", onPressed: onLoginClick),
                        ],
                      )))),
              Spacer()
            ]))));
  }

  /// 登录点击事件
  void onLoginClick() {
    this.fieldErrorValueNotify.value = null;
    if (repwdController.text != pwdController.text) {
      final error = Map<String, dynamic>();
      error["repwd"] = ["新密码和确认密码不一致"];
      this.fieldErrorValueNotify.value = error;
      return;
    }
    ModifyApi.modify(oldPwd: oldPwdController.text, pwd: pwdController.text).fail((code, _, data) async {
      if (code == 2) {
        //表单验证失败
        this.fieldErrorValueNotify.value = data as Map<String, dynamic>?;
        return true;
      }
      return false;
    }).post(() async {
      this.context.toast("密码修改成功");
      SettingShared.logout();
      this.context.relaunch(LoginPage());
    }, this.context);
  }
}
