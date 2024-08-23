import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/extension/Number++.dart';
import 'package:dairo_dfs_app/uc/UCButton.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../Const.dart';
import '../../../../db/dto/DownloadDto.dart';
import '../../../../uc/item/ItemLabel.dart';

class UCDownloadInfoDialog {
  static void show(BuildContext context, DownloadDto dto) {
    _showDetail(context, dto);
  }

  static void _showDetail(BuildContext context, DownloadDto dto) {
    final propertyItemList = <Widget>[Text("属性")];
    propertyItemList.add(ItemLabel("名称", tip: dto.name).hideLine());
    propertyItemList.add(ItemLabel("大小", tip: dto.size.dataSize).hideLine());
    propertyItemList.add(ItemLabel("保存路径", tip: dto.path).hideLine());

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Const.RADIUS))),
              content: IntrinsicHeight(
                  child: Column(children: [
                Text("属性"),
                ItemLabel("名称", tip: dto.name).hideLine(),
                ItemLabel("大小", tip: dto.size.dataSize).hideLine(),
                ItemLabel("保存路径", tip: dto.path).hideLine(),
              ])));
        });
  }
}
