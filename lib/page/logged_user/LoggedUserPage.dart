import 'package:dairo_dfs_app/page/logged_user/uc/UCLoggedUserGroup.dart';
import 'package:dairo_dfs_app/page/logged_user/uc/UCLoggedUserItem.dart';
import 'package:dairo_dfs_app/page/login/LoginType.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/bean/AccountInfo.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/uc/UCButton.dart';
import '../../uc/dialog/UCAlertDialog.dart';
import '../../util/shared_preferences/SettingShared.dart';
import '../login/LoginPage.dart';

/// 查看已经登录用户列表页面
class LoggedUserPage extends StatefulWidget {
  const LoggedUserPage({super.key});

  @override
  State<LoggedUserPage> createState() => _LoggedUserPageState();
}

class _LoggedUserPageState extends State<LoggedUserPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("账号管理"),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20),
              context.textSecondarySmall("切换账号（长按可编辑、删除）"),
              Gap(3),
              UCLoggedUserGroup(
                  children: SettingShared.loggedUserList.map((it) => UCLoggedUserItem(it, onSelect: this.onSelect, onDelete: this.onDelete)).toList()),
              Gap(30),
              UCButton("添加账号", onPressed: () {
                context.toPage(LoginPage(type: LoginType.ADD));
              })
            ],
          ),
        ));
  }

  ///选择点击事件
  void onSelect(AccountInfo account) {
    UCAlertDialog.show(super.context, msg: "确定切换到该账号？", okFun: () {
      SettingShared.login(account, super.context, () {
        super.context.toast("切换成功");
        setState(() {});
      }, (code, msg, data) {
        super.context.toast(msg);
        return false;
      });
    }, cancelFun: () {});
  }

  ///删除带安吉事件
  void onDelete(AccountInfo account) {
    var msg = "确定删除该账号？";
    if (account.isLogining) {
      msg += "该账户为当前登录状态，删除后需要重新登录！";
    }
    UCAlertDialog.show(super.context, msg: msg, okFun: () {
      final logined = SettingShared.loggedUserList;
      for (var i = 0; i < logined.length; i++) {
        final it = logined[i];
        if (it.domain == account.domain && it.name == account.name) {
          logined.removeAt(i);
          break;
        }
      }
      SettingShared.loggedUserList = logined;
      if (account.isLogining) {
        SettingShared.logout();
        super.context.relaunch(LoginPage());
      } else {
        super.context.toast("删除成功");
        setState(() {});
      }
    }, cancelFun: () {});
  }
}
