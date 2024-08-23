import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';

///条目按钮
abstract class ItemBase extends StatelessWidget {

  ///底边线颜色
  static const BORDER_LINE_COLOR = 0x22000000;

  ///底边线宽度
  static const BORDER_LINE_WIDTH = .7;

  ///高度
  static const HEIGHT = 42.0;

  ///标题
  final String label;

  ///图标
  final IconData? icon;

  ///提示信息
  final String tip;

  ///是否显示底边线
  var isShowLine = true;

  ItemBase(this.label,{
    super.key, this.icon, this.tip = "",
  });

  ItemBase hideLine(){
    this.isShowLine = false;
    return this;
  }

  ///图标
  @protected
  Widget ico(BuildContext context){
    return this.icon == null ? const SizedBox() : Icon(this.icon, size: 18, color: context.color.onSurface);
  }
}
