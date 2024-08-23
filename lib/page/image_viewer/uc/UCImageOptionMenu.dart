import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dairo_dfs_app/Const.dart';
import 'package:dairo_dfs_app/extension/String++.dart';
import 'package:dairo_dfs_app/util/cache/AppCacheManager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../uc/UCOptionMenuButton.dart';
import '../../../db/dao/DownloadDao.dart';
import '../../../db/dto/DownloadDto.dart';
import '../../../util/download/DownloadTask.dart';
import '../../../util/shared_preferences/SettingShared.dart';
import '../ImageViewerPage.dart';

///图片操作菜单
class UCImageOptionMenu extends StatelessWidget {
  final GlobalKey _globalKey = GlobalKey();

  ///图片预览页面
  final ImageViewerPageState state;

  UCImageOptionMenu(
    this.state, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: context.color.primaryContainer.withOpacity(.5),
        child: SafeArea(
            top: false,
            child: IntrinsicHeight(
                child: Row(children: [
              UCOptionMenuButton("下载", icon: Icons.download_for_offline_outlined, onPressed: () async {
                await this.onDownloadClick(context);
              }),
              UCOptionMenuButton("分享", icon: Icons.share, onPressed: () async {
                await this.onShareClick(context);
              }),
            ]))));
  }

  ///下载
  Future<void> onDownloadClick(BuildContext context) async {
    final dfsFile = this.state.currentDfs;
    final int? saveToImageGallery;
    if (Platform.isIOS || Platform.isAndroid) {
      saveToImageGallery = await showModalActionSheet(context: context, cancelLabel: "取消", style: AdaptiveStyle.macOS, actions: [
        SheetAction(label: "添加到下载列表", key: 0, textStyle: TextStyle(color: context.color.onSurface)),
        SheetAction(label: "保存到手机相册", key: 1, textStyle: TextStyle(color: context.color.onSurface))
      ]);
      if (saveToImageGallery == null) {
        return;
      }
    } else {
      saveToImageGallery = 0;
    }
    final String url;
    if(saveToImageGallery == 1){//保存到相册时要下载预览图
      url = this.state.previewUrl;
    }else{
      url = dfsFile.preview;
    }

    //添加到下载列表
    final dto = DownloadDto(
        name: dfsFile.name,
        path: "${SettingShared.downloadPath}/${dfsFile.name}",
        url: url,
        thumb: dfsFile.thumb,
        saveToImageGallery: saveToImageGallery);
    DownloadDao.insert([dto]);
    DownloadTask.start();
    context.toast("已添加到下载列表");
  }

  ///分享按钮点击事件
  Future<void> onShareClick(BuildContext context) async {
    final dfsFile = this.state.currentDfs;
    final cacheFile = AppCacheManager.getCacheFile(dfsFile.preview);
    if (!cacheFile.existsSync()) {
      context.toast("请等待图片加载完成");
      return;
    }

    //保存缓存文件名
    final cachePath = cacheFile.path;

    //临时分享的文件名
    final sharePath = cacheFile.path.fileParent + "/" + dfsFile.name;
    try {
      //临时重命名文件,分享到的APP能正确处理文件
      cacheFile.renameSync(sharePath);
      final shareFiles = [XFile(sharePath)];

      await Share.shareXFiles(shareFiles);
    } finally {
      //还原回原来的文件名
      File(sharePath).renameSync(cachePath);
    }
  }
}
