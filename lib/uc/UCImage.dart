import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import '../util/cache/AppCacheManager.dart';

/// 文件列表页面
class UCImage extends StatefulWidget {
  ///按钮文本
  final String url;

  ///图片宽
  final double width;

  ///图片高
  final double height;

  ///图片高
  final double radius;

  ///是否检查已经下载
  final bool checkedDownload;

  const UCImage(this.url, {super.key, required this.width, required this.height, this.radius = 0, this.checkedDownload = true});

  @override
  State<UCImage> createState() => _UCImageState();
}

class _UCImageState extends State<UCImage> {
  ///缓存管理
  late AppCacheManager cacheManager;

  ///下载完成结果通知
  late ValueNotifier downloadVN = ValueNotifier<Widget>(SizedBox(width: this.widget.width, height: this.widget.width));

  @override
  void initState() {
    super.initState();
    this.cacheManager = AppCacheManager(this.widget.url, checkedDownload: this.widget.checkedDownload, onSuccess: (file) {
      this.downloadVN.value = ClipRRect(
          borderRadius: BorderRadius.circular(this.widget.radius),
          child: Image.file(file, width: this.widget.width, height: this.widget.width, fit: BoxFit.fill));
    });
  }

  @override
  void dispose() {
    super.dispose();
    this.cacheManager.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return this.downloadVN.build((value) => value);
  }
}
