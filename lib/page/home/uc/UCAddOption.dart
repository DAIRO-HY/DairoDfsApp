import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/String++.dart';
import 'package:dairo_dfs_app/util/WaitDialog.dart';
import 'package:dairo_dfs_app/util/even_bus/EventUtil.dart';

import '../../../Const.dart';
import '../../../api/FilesApi.dart';
import '../../../db/dao/UploadDao.dart';
import '../../../db/dto/UploadDto.dart';
import '../../../uc/dialog/UCInputDialog.dart';
import '../../../util/even_bus/EventCode.dart';
import '../../../util/shared_preferences/SettingShared.dart';
import '../../../util/upload/UploadTask.dart';
import '../../transfer/TransferPage.dart';

///操作菜单自定义组件
class UCAddOption {
  static void show(BuildContext context) {
    showDialog(
        context: context,
        //barrierDismissible: true, //禁止区域外点击关闭
        builder: (_) => Center(
                child: Container(
              width: 240,
              height: 240,
              child: Column(
                children: [
                  Row(children: [
                    UCAddOptionButton("文件", Icons.insert_drive_file, onPressed: () {
                      onUploadClick(context, FileType.any);
                    }),
                    UCAddOptionButton("上传文件夹", Icons.drive_folder_upload_rounded, onPressed: () {
                      onCreateFolderClick(context);
                    })
                  ]),
                  Row(children: [
                    UCAddOptionButton("图片/视频", Icons.image, onPressed: () {
                      onUploadClick(context, FileType.media);
                    }),
                    UCAddOptionButton("创建文件夹", Icons.create_new_folder, onPressed: () {
                      onCreateFolderClick(context);
                    })
                  ]),
                ],
              ),
            )));
  }

  ///上传文件按钮点击事件
  static Future<void> onUploadClick(BuildContext context, FileType type) async {
    Navigator.of(context).pop();

    //文件选择时可能需要从ICloud下载,需要花费时间,所以这里最好显示等待框
    WaitDialog.show(context);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      //压缩质量越低，文件大小越小，但图像质量也会随之降低。0-100。
      //compressionQuality: 1,

      //指定只选择文件类型。
      type: type,

      //自定义文件选择对话框的标题。
      dialogTitle: "选择上传文件",

      //锁定父窗口，使用户在文件选择对话框打开时无法与其他窗口内容进行交互。
      lockParentWindow: true,

      //允许多选
      allowMultiple: true,
    );
    WaitDialog.hide(context);
    if (result != null) {
      //获取最后一次打开的文件夹
      final lastOpenFolder = SettingShared.lastOpenFolder;
      final downloadDtoList = result.paths.map((it) {
        final dto = UploadDto(name: it!.fileName, size: File(it).lengthSync(), path: it, dfsFolder: lastOpenFolder);
        return dto;
      }).toList();

      //添加到数据库
      UploadDao.insert(downloadDtoList);
      UploadTask.start();

      context.toPage(TransferPage(pageTag: TransferPage.PAGE_UPLOAD));

      //通知文件页面的同步标识按钮显示
      EventUtil.post(EventCode.UPLOAD_PAGE_RELOAD);
    }
  }

  ///创建文件夹点击事件
  static void onCreateFolderClick(BuildContext context) {
    Navigator.of(context).pop();
    UCInputDialog.show(context, title: "新建文件夹", okFun: (value) {
      //获取最后一次打开的文件夹
      final lastOpenFolder = SettingShared.lastOpenFolder;
      final folder = lastOpenFolder + "/" + value;
      FilesApi.createFolder(folder: folder).post(() async{
        EventUtil.post(EventCode.FILE_PAGE_RELOAD);
      }, context);
    });
  }
}

class UCAddOptionButton extends StatelessWidget {
  ///按钮标题
  final String label;

  ///按钮图标
  final IconData icon;

  ///点击回调事件
  final VoidCallback onPressed;

  const UCAddOptionButton(
    this.label,
    this.icon, {
    super.key,
    required this.onPressed,
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
        onPressed: () {
          this.onPressed();
        },
        child: Container(
          width: 80,
          height: 80,
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(color: context.color.primaryContainer, borderRadius: BorderRadius.circular(Const.RADIUS)),
          child: Center(
              child: IntrinsicHeight(
                  child: Column(children: [
            Icon(
              this.icon,
              color: context.color.onSurface,
            ),
            context.textSmall(this.label)
          ]))),
        ));
  }
}
