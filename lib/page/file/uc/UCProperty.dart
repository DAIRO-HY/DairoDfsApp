import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/api/FilesApi.dart';

import '../../../Const.dart';
import '../../../api/model/FilePropertyModel.dart';
import '../../../uc/item/ItemLabel.dart';

class UCProperty {
  static void show(BuildContext context, List<String> paths) {
    FilesApi.getProperty(paths: paths).post((property) async{
      _showDetail(context, property);
    }, context);
  }

  static void _showDetail(BuildContext context, FilePropertyModel property) {
    final propertyItemList = <Widget>[
      Text("属性")
    ];
    if (property.name != null) {
      propertyItemList.add(ItemLabel("名称", tip: property.name!).hideLine());
    }
    if (property.size != null) {
      propertyItemList.add(ItemLabel("大小", tip: property.size!).hideLine());
    }
    if (property.date != null) {
      propertyItemList.add(ItemLabel("创建时间", tip: property.date!).hideLine());
    }
    if (property.path != null) {
      propertyItemList.add(ItemLabel("路径", tip: property.path!).hideLine());
    }
    if (property.contentType != null) {
      propertyItemList.add(ItemLabel("文件类型", tip: property.contentType!).hideLine());
    }
    if (property.folderCount != null) {
      propertyItemList.add(ItemLabel("文件夹数", tip: property.folderCount.toString()).hideLine());
    }
    if (property.fileCount != null) {
      propertyItemList.add(ItemLabel("文件数", tip: property.fileCount.toString()).hideLine());
    }

    if (property.historyList != null && property.historyList!.isNotEmpty) {
      //有历史版本
      propertyItemList.add(ItemLabel("历史版本").hideLine());

      final historyList = <TableRow>[];
      historyList.add(const TableRow(
          children: [
        TableCell(child: Text("日期")),
        TableCell(child: Text("大小")),
        TableCell(child: Text("操作")),
      ]));
      for (var it in property.historyList!) {
        historyList.add(TableRow(children: [
          TableCell(child: Text(it.date!)),
          TableCell(child: Text(it.size!)),
          TableCell(child: Icon(Icons.cloud_download_outlined)),
        ]));
      }
      propertyItemList.add(Table(
        border: TableBorder.all(),
        children: historyList,
      ));
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Const.RADIUS))),
            content: IntrinsicHeight(child: Column(children: propertyItemList))
          );
        });
  }
}
