import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import 'package:photo_view/photo_view.dart';

import '../../../util/cache/AppCacheManager.dart';
import '../ImageViewerPage.dart';

/// 图片浏览器
class UCImageViewer extends StatefulWidget {
  ///缩略图图片下载地址
  final String? thumbUrl;

  ///图片下载地址
  final String url;

  ///图片控制器
  final PhotoViewController _photoController;

  const UCImageViewer(this.thumbUrl, this.url, this._photoController, {super.key});

  @override
  State<UCImageViewer> createState() => _UCImageViewerState();
}

class _UCImageViewerState extends State<UCImageViewer> {

  ValueNotifier<File?> imageVN = ValueNotifier(null);

  ///文件缓存管理
  AppCacheManager? cache;

  @override
  void initState() {
    super.initState();
    this.cache = AppCacheManager(this.widget.url, onSuccess: (file) {
      this.imageVN.value = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return this.imageVN.build((value) {
      if (value == null) {
        final wait = Center(child: SizedBox(width: 60, height: 60, child: CircularProgressIndicator(strokeWidth: 2)));
        if (this.widget.thumbUrl == null) {
          //有可能服务端还没有生成缩略图
          return wait;
        }
        //获取缩率图的缓存文件
        final thumbCacheFile = AppCacheManager.getCacheFile(this.widget.thumbUrl!);
        if (!thumbCacheFile.existsSync()) {
          return wait;
        }
        return Stack(children: [Positioned.fill(child: Image.file(thumbCacheFile, fit: BoxFit.cover)), wait]);
      }
      return PhotoView(
          initialScale: PhotoViewComputedScale.contained * 1,
          //默认全屏显示
          controller: this.widget._photoController,
          // minScale: PhotoViewComputedScale.contained * 1,
          // maxScale: PhotoViewComputedScale.contained * 3,
          minScale: ImageViewerPage.MIN_SCALE,
          maxScale: ImageViewerPage.MAX_SCALE,
          imageProvider: FileImage(value));
    });
  }

  @override
  void dispose() {
    this.widget._photoController.dispose();
    super.dispose();
    // print("-->图片加载被回收");
    this.cache?.cancel();
  }
}
