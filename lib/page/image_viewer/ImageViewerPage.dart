import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import 'package:dairo_dfs_app/page/file/bean/DfsFileBean.dart';
import 'package:dairo_dfs_app/page/image_viewer/uc/UCImageOptionMenu.dart';
import 'package:dairo_dfs_app/page/image_viewer/uc/UCImageViewer.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// 图片浏览器
class ImageViewerPage extends StatefulWidget {
  ///最大放大倍数
  static const MAX_SCALE = 2.0;

  ///最小放大倍数
  static const MIN_SCALE = 0.01;

  ///当前浏览文件列表
  final List<DfsFileBean> dfsFileList;

  ///当前显示的序号
  int currentIndex;

  ImageViewerPage({super.key, required this.dfsFileList, required this.currentIndex});

  @override
  State<ImageViewerPage> createState() => ImageViewerPageState();
}

class ImageViewerPageState extends State<ImageViewerPage> {
  ///PageView控制器
  late final PageController _pageController;

  ///图片控制器
  late PhotoViewController _photoController;

  ///文件名变化通知
  final nameVN = ValueNotifier("");

  ///放大倍率值变化通
  final scaleVN = ValueNotifier(ImageViewerPage.MIN_SCALE);

  ///页面控制按钮显示不显示通知
  final controllerVN = ValueNotifier(true);

  ///得到当前DFS文件
  DfsFileBean get currentDfs => this.widget.dfsFileList[this.widget.currentIndex];

  ///预览url
  String get previewUrl {
    final dfs = this.currentDfs;
    final lowerName = dfs.name.toLowerCase();
    final url = dfs.preview;
    if (lowerName.endsWith("psd") ||
        lowerName.endsWith("psb") ||
        lowerName.endsWith("cr3") ||
        lowerName.endsWith("cr2") ||
        lowerName.endsWith("cr3") ||
        lowerName.endsWith("cr2")) {
      if (url.contains("?")) {
        return "$url&extra=preview";
      } else {
        return "$url?extra=preview";
      }
    }
    return url;
  }

  @override
  void initState() {
    super.initState();
    this._pageController = PageController(initialPage: this.widget.currentIndex);
    this.onImageChange(this.widget.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false, //禁止侧滑返回
        child: Scaffold(
            body: this.controllerVN.build((value) {
          final views = <Widget>[this.photoView];
          if (value) {
            views.add(this.titleBar); //标题栏
            if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
              //指定某些平台才显示
              views.add(this.scaleSlider); //图片放大缩小进度条
              views.add(this.jumpIconBtn); //切换图片按钮
            }

            //底部操作菜单
            views.add(Align(alignment: Alignment.bottomLeft, child: UCImageOptionMenu(this)));
          }
          return Stack(children: views);
        })));
  }

  ///切换图片按钮
  Align get jumpIconBtn => Align(
      alignment: Alignment.center,
      child: Row(children: [
        TextButton(
            style: TextButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              // 选填：紧凑的点击目标尺寸
              padding: EdgeInsets.zero,
              backgroundColor: Color(0x33000000),
              // 设置背景颜色
              //foregroundColor: fontColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999999), // 设置圆角
              ),
              minimumSize: Size(0, 0), // 设置宽度和高度
            ),
            onPressed: () {
              this._pageController.previousPage(
                    duration: Duration(milliseconds: 250), curve: Curves.easeInOut, // 动画曲线
                  );
            },
            child: SizedBox(
                height: 40,
                child: Center(
                    child: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 40,
                )))),
        Spacer(),
        TextButton(
            style: TextButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              // 选填：紧凑的点击目标尺寸
              padding: EdgeInsets.zero,
              backgroundColor: Color(0x33000000),
              // 设置背景颜色
              //foregroundColor: fontColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999999), // 设置圆角
              ),
              minimumSize: Size(0, 0), // 设置宽度和高度
            ),
            onPressed: () {
              this._pageController.nextPage(
                    duration: Duration(milliseconds: 250), curve: Curves.easeInOut, // 动画曲线
                  );
            },
            child: SizedBox(
                height: 40,
                child: Center(
                    child: Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 40,
                ))))
      ]));

  ///图片
  PhotoViewGallery get photoView => PhotoViewGallery.builder(
      pageController: this._pageController,
      scrollPhysics: const BouncingScrollPhysics(),
      itemCount: this.widget.dfsFileList.length,
      onPageChanged: this.onImageChange,
      builder: (BuildContext context, int index) {
        // print("-->index$index");
        this.widget.currentIndex = index;
        final dfs = this.currentDfs;

        this._photoController = PhotoViewController();
        this._photoController.outputStateStream.listen((value) {
          //放大缩小监听
          this.scaleVN.value = value.scale!;
        });
        return PhotoViewGalleryPageOptions.customChild(
            // minScale: PhotoViewComputedScale.contained * 1,
            // maxScale: PhotoViewComputedScale.contained * 5,
            // initialScale: PhotoViewComputedScale.contained * 1,
            heroAttributes: PhotoViewHeroAttributes(tag: dfs.id),
            //imageProvider: this.getCurrentImage(dfs, index),
            // child: Image.asset("assets/images/no_img.png"),
            child: GestureDetector(
              onTap: () {
                //页面控制按钮显示不显示设置
                this.controllerVN.value = !this.controllerVN.value;
              },
              child: UCImageViewer(dfs.thumb, this.previewUrl, this._photoController),
            )
            // this.getCurrentImage(dfs, index),
            );
      });

  ///标题栏
  Container get titleBar => Container(
      color: Color(0x44000000),
      child: IntrinsicHeight(
        child: SafeArea(
            bottom: false, //去掉底部的内边距
            child: Column(children: [
              Gap(5),
              Row(
                children: [
                  Gap(5),
                  TextButton(
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        // 选填：紧凑的点击目标尺寸
                        padding: EdgeInsets.zero,
                        backgroundColor: Color(0x33000000),
                        // 设置背景颜色
                        //foregroundColor: fontColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999999), // 设置圆角
                        ),
                        minimumSize: Size(0, 0), // 设置宽度和高度
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Center(
                              child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          )))),
                  Expanded(
                      child: Align(
                          alignment: Alignment.center,
                          child: this.nameVN.build((value) => Text(
                                value,
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              )))),
                  Gap(45)
                ],
              ),
              Gap(5),
            ])),
      ));

  ///图片放大缩小进度条
  Positioned get scaleSlider => Positioned(
      bottom: 0,
      right: 0,
      child: SizedBox(
          height: 200,
          child: RotatedBox(
              quarterTurns: -1, //旋转90°
              child: this.scaleVN.build((value) {
                if (value > ImageViewerPage.MAX_SCALE) {
                  //手动放大时有可能超过最大值
                  value = ImageViewerPage.MAX_SCALE;
                } else if (value < ImageViewerPage.MIN_SCALE) {
                  //手动缩小时有可能超过最小值
                  value = ImageViewerPage.MIN_SCALE;
                } else {
                  ;
                }

                return Slider(
                    value: value,
                    min: ImageViewerPage.MIN_SCALE,
                    max: ImageViewerPage.MAX_SCALE,
                    onChanged: (value) {
                      this._photoController.scale = value;
                    });
              }))));

  ///图片切换事件
  void onImageChange(index) {
    final dfs = this.widget.dfsFileList[index];
    this.nameVN.value = dfs.name;
  }

  @override
  void dispose() {
    super.dispose();
    this._pageController.dispose();
  }
}
