import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';

import '../../../Const.dart';
import '../../../api/FilesApi.dart';
import '../../../db/dao/DownloadDao.dart';
import '../../../db/dto/DownloadDto.dart';
import '../../../util/download/DownloadTask.dart';
import '../../../util/even_bus/EventCode.dart';
import '../../../util/even_bus/EventUtil.dart';
import '../../../util/http/ApiHttp.dart';
import '../../../util/shared_preferences/SettingShared.dart';
import '../../transfer/TransferPage.dart';
import '../bean/DfsFileBean.dart';

///等待下载弹出框
class UCDownloadWaitDialog {

  ///选中要下载的文件
  final List<DfsFileBean> selectedDownload;

  ///文件下载数变化通知
  final countVN = ValueNotifier(0);

  ///是否已经取消
  var isCancel = false;

  ///当前正在发起请求的http
  ApiHttp? http;

  ///d当前正在打开的文件夹
  final dfsBasePath = SettingShared.lastOpenFolder;

  ///下载目录
  final saveFolder = SettingShared.downloadPath;

  BuildContext context;

  UCDownloadWaitDialog(this.context, this.selectedDownload);

  void show() async {
    this._showWaitDialog();
    final downloadList = <DownloadDto>[];
    for (var it in this.selectedDownload) {
      await this._loopDownload(downloadList, it);
    }

    Navigator.of(this.context).pop();
    if (this.isCancel) {
      this.context.toast("下载已取消");
      return;
    }

    //添加到数据库
    DownloadDao.insert(downloadList);
    DownloadTask.start();
    this.context.toPage(TransferPage(pageTag: TransferPage.PAGE_DOWNLOAD));

    //通知文件页面的同步标识按钮显示
    EventUtil.post(EventCode.DOWNLOAD_PAGE_RELOAD);
  }

  ///显示Dialog
  void _showWaitDialog(){
    final alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Const.RADIUS),
      ),
      content: IntrinsicHeight(
          child: Column(children: [
            Center(child: SizedBox(width: 60, height: 60, child: CircularProgressIndicator(strokeWidth: 2, color: this.context.color.onSurface))),
            Gap(10),
            this.countVN.build((value) => this.context.textBody("$value个文件准备下载"))
          ])),
      actions: [
        TextButton(
          child: this.context.textBody("取消下载"),
          onPressed: () {
            this.isCancel = true;
            this.http?.cancel();
          },
        )
      ],
    );

    showDialog(
        barrierDismissible: false, //禁止区域外点击关闭
        context: this.context,
        builder: (context) {
          return alert;
        });
  }

  ///循环下载文件夹下的所有的文件
  Future<void> _loopDownload(List<DownloadDto> downloadList, DfsFileBean dfsBean) async {
    if (this.isCancel) {
      return;
    }
    if (dfsBean.fileFlag) {

      //文件存储路径
      final savePath = "$saveFolder${dfsBean.path.replaceFirst(this.dfsBasePath, "")}";

      //如果这是一个文件,直接下载
      final dto = DownloadDto(
          thumb: dfsBean.thumb, name: dfsBean.name, size: dfsBean.size, path: savePath, url: dfsBean.preview);
      downloadList.add(dto);
      this.countVN.value = downloadList.length;
      return;
    }

    //如果这是一个文件夹,则下载该文件夹下所有文件
    final http = FilesApi.getList(folder: dfsBean.path);
    this.http = http;
    await http.error((msg) async {
      this.context.toast(msg);
      this.isCancel = true;
    }).fail((code, msg, _) async {
      this.context.toast(msg);
      this.isCancel = true;
      return true;
    }).post((list) async {
      for (var it in list) {
        final dfs = DfsFileBean(dfsBean.path, it);
        await this._loopDownload(downloadList, dfs);
      }
    });
  }
}
