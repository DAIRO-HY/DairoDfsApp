import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/db/dao/DownloadDao.dart';
import 'package:dairo_dfs_app/db/dao/UploadDao.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/List++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import 'package:dairo_dfs_app/page/account/AccountPage.dart';
import 'package:dairo_dfs_app/page/transfer/TransferPage.dart';
import 'package:dairo_dfs_app/uc/UCButton.dart';
import 'package:dairo_dfs_app/uc/item/ItemSelect.dart';
import 'package:dairo_dfs_app/util/even_bus/EventCode.dart';
import 'package:dairo_dfs_app/util/even_bus/EventUtil.dart';

import '../../main.dart';
import '../../uc/item/ItemButton.dart';
import '../../uc/item/ItemGroup.dart';
import '../../util/SyncVariable.dart';
import '../../util/shared_preferences/SettingShared.dart';
import '../ListViewPage.dart';
import '../cache/CachePage.dart';
import '../login/LoginPage.dart';
import '../modify_pwd/ModifyPwdPage.dart';
import '../trash/TrashPage.dart';

/// 我的页面
class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  ///账号变更通知
  final accountVn = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    EventUtil.regist(this, EventCode.ACCOUNT_CHANGE, (_) => accountVn.value++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          this.topAcountView,
          Expanded(
              child: SingleChildScrollView(
            child: SafeArea(
                top: false,
                bottom: false,
                child: Column(
                  children: [
                    Gap(20),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: [
                          ItemGroup(children: [
                            // ItemButton("我的分享", tip: "我分享的文件", icon: Icons.share, onPressed: () {
                            //   context.toPage(ListViewPage());
                            // }),
                            ItemButton(
                              "回收站",
                              tip: "删除的文件",
                              icon: Icons.auto_delete_outlined,
                              onPressed: () {
                                context.toPage(TrashPage());
                              },
                            ),
                            ItemButton("传输列表", tip: "上传/下载列表", icon: Icons.sync, onPressed: () {
                              if (DownloadDao.selectDownloadCount() > 0) {
                                context.toPage(TransferPage(pageTag: TransferPage.PAGE_DOWNLOAD));
                              } else if (UploadDao.selectUploadCount() > 0) {
                                context.toPage(TransferPage(pageTag: TransferPage.PAGE_UPLOAD));
                              } else {
                                context.toPage(TransferPage());
                              }
                            })
                          ]),
                          Gap(20),
                          ItemGroup(children: [
                            ItemButton("缓存管理", icon: Icons.save, onPressed: () {
                              context.toPage(CachePage());
                            }),
                            ItemButton("修改密码", tip: "重置密码", icon: Icons.lock_reset_outlined, onPressed: () {
                              context.toPage(ModifyPwdPage());
                            })
                          ]),
                          Gap(20),
                          ItemGroup(children: [
                            ItemSelect("主题设置",
                                value: SettingShared.theme,
                                icon: Icons.color_lens,
                                options: [ItemSelectOption("跟随系统", 0), ItemSelectOption("明亮模式", 1), ItemSelectOption("黑暗模式", 2)], onChange: (value) {
                              SettingShared.theme = value;
                              MyApp.themeVn.value = value as int;
                            })
                          ]),
                          Gap(30),
                          UCButton("退出登录", onPressed: () {
                            SettingShared.logout();
                            Navigator.pushAndRemoveUntil(
                                context, MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false);
                          })
                        ],
                      ),
                    )
                  ],
                )),
          ))
        ],
      ),
    );
  }

  ///顶部账号信息
  Widget get topAcountView => TextButton(
      style: TextButton.styleFrom(
          minimumSize: const Size(0, 0), // 选填：设置最小尺寸
          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 选填：紧凑的点击目标尺寸
          padding: EdgeInsets.zero, //设置没有内边距
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // 设置圆角
          )),
      onPressed: () {
        context.toPage(AccountPage());
      },
      child: Container(
        color: context.color.primary,
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              Gap(10),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                width: 60,
                height: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), color: Colors.white),
                child: Icon(
                  Icons.person,
                  size: 55,
                  color: context.color.primary,
                ),
              ),
              Gap(10),
              accountVn.build((_) {
                final account = SettingShared.logined.find((it) => it.isLogining);
                if (account == null) {
                  return SizedBox();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(account.name, style: TextStyle(fontSize: 30, color: Colors.white)),
                    context.textBody(account.domain,color: Color(0x88FFFFFF))
                  ],
                );
              }),
              Spacer(),
              //Text("切换账号", style: TextStyle(fontSize: 12, color: Color(0x88FFFFFF))),
              Icon(
                Icons.chevron_right,
                size: 30,
                color: Color(0x88FFFFFF),
              ),
              Gap(10)
            ],
          ),
        ),
      ));

  @override
  void dispose() {
    super.dispose();
    EventUtil.unregist(this);
  }
}
