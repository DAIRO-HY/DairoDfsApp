import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/page/home/uc/UCTabBtnLand.dart';
import 'package:dairo_dfs_app/util/shared_preferences/SettingShared.dart';

import '../file/FilePage.dart';
import 'uc/UCTabBtn.dart';
import 'uc/UCAddOption.dart';
import '../login/LoginPage.dart';
import '../mine/MinePage.dart';

/// 主页页面
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///添加按钮尺寸
  static const BTN_ADD_SIZE = 58.0;

  ///文件页面标识
  static const TAG_FILE = "FILE";

  ///用户页面标识
  static const TAG_MINE = "MINE";

  final filePage = const FilePage();

  ///首页显示页面
  Widget page = const SizedBox();

  late BuildContext _context;

  @override
  void initState() {
    super.initState();

    //页面加载完成之后回调事件
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //如果没有登录
      if (!SettingShared.isLogin) {
        this.context.relaunch(LoginPage());
        return;
      }

      //加载第一个页面
      onTabClick((this.bottonBtns[0] as UCTabBtn).tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    this._context = context;
    if (Platform.isIOS || Platform.isAndroid) {
      return this.mobileTab;
    } else {
      return this.mobileTab;
      // return this.desktopTab;
    }
  }

  //桌面端的TAB按钮
  Widget get desktopTab => Row(
        children: [
          SafeArea(
              child: Container(
            width: 160,
            color: context.color.primary,
            child: Column(
              children: [UCTabBtnLand(text: "文件", tag: TAG_FILE, icon: Icons.folder, onPressed: this.onTabClick), Spacer()],
            ),
          )),
          Expanded(child: page),
        ]);

  //移动端的TAB按钮
  Widget get mobileTab => Stack(children: [
        Column(
          children: [
            Expanded(child: page),
            Container(
                color: this.context.color.primary,
                child: SafeArea(
                    top: false,
                    child: Container(
                        //用来隐藏两个按钮之间的间隙,在某些分辨率,可能会有间隙
                        color: this.context.color.primary,
                        child: Column(children: [
                          Row(
                            children: this.bottonBtns,
                          )
                        ]))))
          ],
        ),

        //添加按钮
        Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
                top: false,
                child:
                TextButton(
                    style: TextButton.styleFrom(
                      //minimumSize: const Size(0, 0), // 选填：设置最小尺寸
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // 选填：紧凑的点击目标尺寸
                      padding: EdgeInsets.zero,
                      backgroundColor: context.color.primary,
                      // 设置背景颜色
                      foregroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99999), // 设置圆角
                      ),
                      minimumSize: Size(0, 0), // 设置宽度和高度
                    ),
                    onPressed: () {
                      UCAddOption.show(context);
                    },
                    child: SizedBox(
                        width: BTN_ADD_SIZE,
                        height: BTN_ADD_SIZE,
                        child: Center(
                            child: Icon(
                          Icons.add_circle,
                          size: BTN_ADD_SIZE - 5,
                          color: Colors.white,
                        ))))))
      ]);

  ///初始化底部按钮
  late List<Widget> bottonBtns = [
    UCTabBtn(text: "文件", tag: TAG_FILE, icon: Icons.folder, onPressed: this.onTabClick),
    Container(color: Colors.transparent, width: 100, height: UCTabBtn.HEIGHT),
    UCTabBtn(text: "我的", tag: TAG_MINE, icon: Icons.person, onPressed: onTabClick)
  ];

  ///导航TAB按钮点击事件
  void onTabClick(String tag) {
    for (var it in bottonBtns) {
      //将当前点击的按钮标记为选中状态
      if (it is! UCTabBtn) {
        continue;
      }
      if (it.tag == tag) {
        it.setSelected(true);
      } else {
        it.setSelected(false);
      }
    }
    setState(() {
      switch (tag) {
        //显示指定页面
        case TAG_FILE:
          this.page = this.filePage;
          break;
        case TAG_MINE:
          this.page = MinePage();
          break;
      }
    });
  }
}
