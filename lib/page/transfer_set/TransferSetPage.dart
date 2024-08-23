import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/uc/item/ItemSelect.dart';
import 'package:dairo_dfs_app/util/download/DownloadTask.dart';
import 'package:dairo_dfs_app/util/shared_preferences/SettingShared.dart';
import '../../uc/item/ItemButton.dart';
import '../../uc/item/ItemGroup.dart';
import '../../util/upload/UploadTask.dart';

/// 文件传输设置页面
class TransferSetPage extends StatefulWidget {
  const TransferSetPage({super.key});

  @override
  State<TransferSetPage> createState() => _TransferSetPageState();
}

class _TransferSetPageState extends State<TransferSetPage> {
  @override
  void initState() {
    super.initState();

    //页面加载完成之后回调事件
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await this.compute();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("传输设置")),
        body: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(20),
                context.textSecondarySmall("下载"),
                Gap(3),
                ItemGroup(children: [
                  ItemSelect("同时下载数", value: SettingShared.downloadSyncCount, options: [
                    ItemSelectOption("1", 1),
                    ItemSelectOption("2", 2),
                    ItemSelectOption("3", 3),
                    ItemSelectOption("4", 4),
                    ItemSelectOption("5", 5)
                  ], onChange: (value) {
                    SettingShared.downloadSyncCount = value as int;
                    DownloadTask.syncCount = value;
                    DownloadTask.start();
                  }),
                  ItemButton("下载目录", tip: SettingShared.downloadPath, onPressed: () async {
                    if(Platform.isIOS || Platform.isAndroid){
                      return;
                    }
                    final String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
                      dialogTitle: "请选择下载目录",
                      lockParentWindow: true,
                      initialDirectory: SettingShared.downloadPath
                    );
                    if (selectedDirectory != null) {
                      SettingShared.downloadPath = selectedDirectory;
                      setState(() {});
                    }
                  }),
                ]),
                Gap(20),
                context.textSecondarySmall("上传"),
                Gap(3),
                ItemGroup(children: [
                  ItemSelect("同时上传数", value: SettingShared.uploadSyncCount, options: [
                    ItemSelectOption("1", 1),
                    ItemSelectOption("2", 2),
                    ItemSelectOption("3", 3),
                    ItemSelectOption("4", 4),
                    ItemSelectOption("5", 5)
                  ], onChange: (value) {
                    SettingShared.uploadSyncCount = value as int;
                    UploadTask.syncCount = value;
                    UploadTask.start();
                  }),
                ]),
              ],
            )));
  }
}
