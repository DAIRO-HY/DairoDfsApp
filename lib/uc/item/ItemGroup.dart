import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';

import 'ItemBase.dart';

///条目分组
class ItemGroup extends StatelessWidget {

  /// 条目列表
  final List<Widget> children;
  ItemGroup({
    super.key, required this.children,
  }){

    final last = this.children.last;
    if(last is ItemBase){

      //最后一个条目不要显示底边线
      last.hideLine();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: 1,
        child: Container(
            decoration: BoxDecoration(
                color: context.color.primaryContainer,
                borderRadius: BorderRadius.circular(8)),
            child: Column(children: this.children)));
  }
}