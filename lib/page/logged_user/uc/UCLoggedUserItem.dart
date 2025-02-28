import 'package:dairo_dfs_app/page/login/LoginType.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';

import '../../../Const.dart';
import '../../../bean/AccountInfo.dart';
import '../../login/LoginPage.dart';

///条目开关
class UCLoggedUserItem extends StatelessWidget {

  ///底边线颜色
  static const BORDER_LINE_COLOR = 0x22000000;

  ///底边线宽度
  static const BORDER_LINE_WIDTH = .7;

  ///高度
  static const HEIGHT = 50.0;

  ///是否显示底边线
  var isShowLine = true;

  ///选择回调事件
  final void Function(AccountInfo account) onSelect;

  ///删除回调事件
  final void Function(AccountInfo account) onDelete;

  ///登录信息
  final AccountInfo account;

  UCLoggedUserItem(
    this.account, {
    super.key,
    required this.onSelect,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
              style: TextButton.styleFrom(
                  minimumSize: const Size(0, 0), // 选填：设置最小尺寸
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 选填：紧凑的点击目标尺寸
                  padding: EdgeInsets.zero, //设置没有内边距
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), // 设置圆角
                  )),
              onPressed: this.account.isLogining
                  ? null
                  : () {
                      this.onSelect(this.account);
                    },
              onLongPress: (){//长按事件
                onLongClick(context);
              },
              child: Container(
                  height: UCLoggedUserItem.HEIGHT,
                  decoration: this.isShowLine
                      ? const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(UCLoggedUserItem.BORDER_LINE_COLOR), width: UCLoggedUserItem.BORDER_LINE_WIDTH)))
                      : null,
                  child: Row(children: [
                    Gap(10),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(child: Align(alignment: Alignment.bottomLeft, child: context.textBody(this.account.name))),
                      Expanded(child: Align(alignment: Alignment.topLeft, child: context.textSecondarySmall(this.account.domain))),
                    ]),
                    const Spacer(),
                    Icon(Icons.check, color: this.account.isLogining ? context.color.onSurface : context.color.surface),
                    Gap(10)
                  ])));
  }

  //长按事件
  void onLongClick(BuildContext context){
    final List<Widget> actions = ["编辑","删除"].map((it) => GestureDetector(
      onTap: () async {
        if(it == "编辑"){
          context.toPage(LoginPage(type: LoginType.EDIT,acc: this.account));
        }else  if(it == "删除"){
          this.onDelete(this.account);
        }
      },
      child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: Row(
            children: [
              Spacer(),
              context.textBody(it),
              Spacer()
            ],
          )),
    )).toList();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ));
      },
    );
  }

  UCLoggedUserItem hideLine() {
    this.isShowLine = false;
    return this;
  }
}
