import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/String++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import 'package:dairo_dfs_app/page/home/HomePage.dart';

import '../../Const.dart';
import '../../bean/AccountInfo.dart';
import '../../uc/UCButton.dart';
import '../../uc/UCInput.dart';
import '../../uc/dialog/UCAlertDialog.dart';
import '../../util/Toast.dart';
import '../../util/shared_preferences/SettingShared.dart';
import '../logged_user/uc/UCLoggedUserGroup.dart';
import '../logged_user/uc/UCLoggedUserItem.dart';
import 'LoginType.dart';

/// 登录页面
class LoginPage extends StatefulWidget {
  ///模式
  final LoginType type;

  ///要编辑的账号
  late final AccountInfo account;

  LoginPage({super.key, this.type = LoginType.LOGIN, AccountInfo? acc}) {
    acc ??= AccountInfo();
    this.account = acc;
  }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ///表单验证失败信息
  final fieldErrorValueNotify = ValueNotifier<Map<String, dynamic>?>(null);

  ///账号密码选择是否显示
  late final accountSelectVisibleVN = ValueNotifier(this.widget.type == LoginType.LOGIN && SettingShared.loggedUserList.isNotEmpty);

  ///服务器输入控制器
  late var domainController = TextEditingController(text: this.widget.account.domain);

  ///用户名输入控制器
  late var nameController = TextEditingController(text: this.widget.account.name);

  ///密码输入控制器
  late var pwdController = TextEditingController(text: this.widget.account.pwd);

  //页面标题
  String get pageTitle {
    switch (this.widget.type) {
      case LoginType.LOGIN:
        return "用户登录";
      case LoginType.ADD:
        return "添加用户";
      case LoginType.EDIT:
        return "编辑用户";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(this.pageTitle)),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [const Color(0xff613a46), context.color.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
            child: Center(
                child: Column(children: [
              Spacer(),
              ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset("assets/images/logo_rect_256.png", width: 80, height: 80)),
              Gap(30),
              Container(
                  width: 320,
                  decoration: BoxDecoration(
                    color: context.color.primaryContainer, // 内层背景色
                    borderRadius: BorderRadius.circular(Const.RADIUS), // 内层圆角
                  ),
                  padding: const EdgeInsets.all(18),
                  // 外层内边距
                  child: IntrinsicHeight(child: this.accountSelectVisibleVN.build((value) => value ? this.selectLoginView : this.inputLoginView))),
              Spacer(),
              Spacer(),
            ]))));
  }

  ///从登录列表中选择登录
  Widget get selectLoginView => Column(children: [
        context.textBody("选择登录账号"),
        //context.textSecondarySmall("长按可编辑、删除"),
        Gap(10),
        Expanded(
            child: UCLoggedUserGroup(
                children: SettingShared.loggedUserList.map((it) => UCLoggedUserItem(it, onSelect: this.onSelect, onDelete: this.onDelete)).toList())),
        Gap(30),
        UCButton("添加账号", onPressed: () {
          this.accountSelectVisibleVN.value = false;
        })
      ]);

  ///用户名密码输入登录框
  Widget get inputLoginView => this.fieldErrorValueNotify.build((value) => Column(children: [
        UCInput(hint: "服务器", controller: domainController, error: this.fieldErrorValueNotify.value?["domain"]?.join(";")),
        const SizedBox(height: 15),
        UCInput(hint: "用户名", controller: nameController, error: this.fieldErrorValueNotify.value?["name"]?.join(";")),
        const SizedBox(height: 15),
        UCInput(hint: "密码", controller: pwdController, password: true, error: this.fieldErrorValueNotify.value?["pwd"]?.join(";")),
        const SizedBox(height: 30),
        UCButton("登录", onPressed: onLoginClick),
        Row(children: [
          Visibility(
              visible: this.widget.type == LoginType.LOGIN && SettingShared.loggedUserList.isNotEmpty,
              child: TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 50)),
                  child: context.textSecondarySmall("选择已登录账户"),
                  onPressed: () {
                    this.accountSelectVisibleVN.value = true;
                  })),
          Spacer(),
          TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 50)),
              child: context.textSecondarySmall("忘记密码"),
              onPressed: () {
                this.context.toast("忘记密码请联系管理员。");
              })
        ])
      ]));

  /// 登录点击事件
  void onLoginClick() {
    //清空错误消息
    this.fieldErrorValueNotify.value = null;
    var domain = domainController.text;
    if (domain.isEmpty) {
      final error = Map<String, dynamic>();
      error["domain"] = ["服务器必填"];
      this.fieldErrorValueNotify.value = error;
      return;
    }
    if (!domain.startsWith("http://") && !domain.startsWith("https://")) {
      //不全url
      domain = "http://" + domain;
    }
    if (domain.endsWith("/")) {
      //去掉最后一个/
      domain = domain.substring(0, domain.length - 1);
    }

    //登录名
    final name = nameController.text;

    //登录密码
    var pwd = pwdController.text;
    if (pwd.isEmpty) {
      final error = Map<String, dynamic>();
      error["pwd"] = ["密码必填"];
      this.fieldErrorValueNotify.value = error;
      return;
    }
    if (pwd.length != 32) {
      pwd = pwd.md5;
    }

    //
    final loggedUserList = SettingShared.loggedUserList;

    //登录信息
    final loginInfo = AccountInfo(domain: domain, name: name, pwd: pwd);
    SettingShared.login(loginInfo, context, () {
      if (this.widget.type == LoginType.EDIT) {
        //如果当前时编辑操作
        for (var it in loggedUserList) {
          //先取消内部所有登录状态
          it.isLogining = false;
        }

        //取出当前要编辑的用户
        var editUser = loggedUserList.firstWhere((it) {
          return it.name == this.widget.account.name && it.domain == this.widget.account.domain;
        });
        editUser.domain = loginInfo.domain;
        editUser.name = loginInfo.name;
        editUser.pwd = loginInfo.pwd;
        editUser.isLogining = true;

        //重新保存列表，替换当前编辑的那一条数据
        SettingShared.loggedUserList = loggedUserList;
      }
      this.context.relaunch(HomePage());
    }, (code, _, data) {
      if (code == 2) {
        //表单验证失败
        this.fieldErrorValueNotify.value = data as Map<String, dynamic>?;
        return true;
      }
      return false;
    });
  }

  ///选择点击事件
  void onSelect(AccountInfo account) {
    SettingShared.login(account, context, () {
      this.context.relaunch(HomePage());
    }, (code, msg, data) {
      Toast.show(context, msg);
      return false;
    });
  }

  ///删除带安吉事件
  void onDelete(AccountInfo account) {
    UCAlertDialog.show(context, msg: "确定删除该账号？", okFun: () {
      final logined = SettingShared.loggedUserList;
      for (var i = 0; i < logined.length; i++) {
        final it = logined[i];
        if (it.domain == account.domain && it.name == account.name) {
          logined.removeAt(i);
          break;
        }
      }
      SettingShared.loggedUserList = logined;
      if (logined.isEmpty) {
        //已经全部删除
        this.accountSelectVisibleVN.value = false;
      } else {
        setState(() {});
      }
      Toast.show(context, "删除成功");
    }, cancelFun: () {});
  }
}
