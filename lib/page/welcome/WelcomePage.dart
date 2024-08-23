import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/api/UserApi.dart';
import 'package:dairo_dfs_app/extension/String++.dart';
import 'package:dairo_dfs_app/page/home/HomePage.dart';
import 'package:dairo_dfs_app/page/login/LoginPage.dart';
import 'package:dairo_dfs_app/util/shared_preferences/SettingShared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/LoginApi.dart';
import '../../api/model/UserInfoModel.dart';
import '../../uc/StateBase.dart';
import '../../uc/UCButton.dart';
import '../../uc/UCInput.dart';
import '../../util/Toast.dart';

/// 登录页面
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  void initState(){
    super.initState();
    // final sp = await SharedPreferences.getInstance();


    //页面加载完成之后回调事件
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   SharedPreferncesUtil.init((){
    //     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(
          padding: EdgeInsets.only(top: 50),
          child: TextButton(child: Text("欢迎使用GLDFS"),onPressed: onBtnClick),
        )  );
  }

  void onBtnClick() async{
    final sp = await SharedPreferences.getInstance();
    print(sp);
  }
}
