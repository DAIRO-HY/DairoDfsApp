import 'package:dairo_dfs_app/api/model/AlbumModel.dart';
import 'package:dairo_dfs_app/page/album/vm/AlbumVM.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import 'package:dairo_dfs_app/page/image_viewer/ImageViewerPage.dart';
import 'package:dairo_dfs_app/page/video_player/VideoPlayerPage.dart';

import '../../../util/shared_preferences/AlbumShared.dart';
import '../../image_viewer/vm/ImageViewerVM.dart';
import '../../video_player/vm/VideoPlayerVM.dart';
import '../AlbumPage.dart';
import 'AlbumGridViewItem.dart';

///文件列表组件
class AlbumGridView extends StatelessWidget {
  ///文件列表改变监听器
  final fileListFlagVN = ValueNotifier(0);

  ///文件页面状态对象
  final AlbumPageState albumPageState;

  /// 相册视图模型列表
  List<AlbumVM> albumVMList = [];

  late BuildContext _context;

  final ScrollController _scrollController = ScrollController();

  AlbumGridView(this.albumPageState, {super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this._scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    this._context = context;
    return Expanded(child: LayoutBuilder(builder: (context, constraints) {
      //要显示的列数
      int columnNum = 3;

      //间距
      var spacing = 2.0;

      //单元格宽度
      var itemWidth =
          (constraints.maxWidth - spacing * (columnNum - 1)) / columnNum;
      return Container(
          color: context.color.primaryContainer,
          child: this.fileListFlagVN.build((value) => GridView.builder(
              //显示倒置
              //reverse: true,
            controller: this._scrollController,
              padding: EdgeInsets.zero,
              itemCount: this.albumVMList.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: itemWidth, // 每个项的最大宽度
                childAspectRatio: 1 / 1, // 宽高比
                crossAxisSpacing: spacing, // 水平间距
                mainAxisSpacing: spacing, // 垂直间距
              ),
              itemBuilder: (context, index) {
                final dfsFile = this.albumVMList[index];

                //文件列表条目
                return fileItemView(dfsFile, itemWidth);
              })));
    }));
  }

  ///文件项目
  Widget fileItemView(AlbumVM dfsFile, double width) => Listener(
      onPointerDown: (PointerDownEvent event) {
        if (event.kind == PointerDeviceKind.mouse &&
            event.buttons == kSecondaryMouseButton) {
          // 处理右键点击事件
          for (final it in this.albumVMList) {
            //右键点击时，默认只选择当前文件
            it.isSelected = false;
          }
          this.albumPageState.selectModeVN.value = true;
          dfsFile.isSelected = true;
          this.albumPageState.selectedCount = 1;
          this.albumPageState.albumOption.redraw();
          this.redraw();
        }
      },
      child: AlbumGridViewItem(
        dfsFile,
        width,
        isSelectMode: this.albumPageState.selectModeVN.value,
        onSelectChange: this.albumPageState.onCheckChange,
        onClick: this.onFileClick,
      ));

  ///当前选中的路径列表
  List<int> get selectedIds =>
      this.albumVMList.where((it) => it.isSelected).map((it) => it.id).toList();

  ///当前选中的路径列表
  List<AlbumVM> get selected =>
      this.albumVMList.where((it) => it.isSelected).toList();

  ///获取文件列表
  void loadList() {
    AlbumShared.list((list) {
      if (this.albumPageState.isFinish) {
        //如果页面已经关闭，那就什么也不做。防止异步操作时，页面被关闭报错
        return;
      }
      this.sort(list);
      this.albumVMList = list.map((it) => AlbumVM(it)).toList();
      this.albumPageState.selectedCount = 0;

      //关闭选择模式
      //this.albumPageState.selectModeVN.value = false;

      //隐藏操作菜单栏
      //this.albumPageState.ucOptionMenu.hide();

      //重回文件页面
      this.redraw();
    });
  }

  ///文件排列
  void sort(List<AlbumModel> dfsList) {
    //排序
    dfsList.sort((p1, p2) {
      return p1.date > p2.date ? 1 : -1;
    });
  }

  ///重绘页面
  void redraw() {
    this.fileListFlagVN.value = this.fileListFlagVN.value++;
  }

  ///重新加载文件列表
  void reload() {
    this.loadList();
  }

  ///文件点击事件
  void onFileClick(AlbumVM dfsFile) {
    //是否图片
    isImageFun(String name) =>
        name.endsWith(".jpg") ||
        name.endsWith(".jpeg") ||
        name.endsWith(".png") ||
        name.endsWith(".jfif") ||
        name.endsWith(".psd") ||
        name.endsWith(".psb") ||
        name.endsWith(".cr3") ||
        name.endsWith(".cr2") ||
        name.endsWith(".heic");

    //是否视频
    isVedio(String name) => name.endsWith(".mp4") || name.endsWith(".mov");
    if (isImageFun(dfsFile.name.toLowerCase())) {
      //如果是图片的话

      //整理所有图片列表
      final imageList = <ImageViewerVM>[];

      //当前选择的序号
      var curentIndex = -1;
      for (var i = 0; i < this.albumVMList.length; i++) {
        final it = this.albumVMList[i];
        if (it == dfsFile) {
          curentIndex = imageList.length;
        }
        if (isImageFun(it.name.toLowerCase())) {
          imageList
              .add(ImageViewerVM(id: it.id, name: it.name, thumb: it.thumb));
        }
      }
      this._context.toPage(
          ImageViewerPage(dfsFileList: imageList, currentIndex: curentIndex));
    } else if (isVedio(dfsFile.name.toLowerCase())) {
      //如果是视频的话

      //整理所有视频列表
      final videoList = <VideoPlayerVM>[];

      //当前选择的序号
      var curentIndex = -1;
      for (var i = 0; i < this.albumVMList.length; i++) {
        final it = this.albumVMList[i];
        if (it == dfsFile) {
          curentIndex = videoList.length;
        }
        if (isVedio(it.name.toLowerCase())) {
          videoList
              .add(VideoPlayerVM(id: it.id, name: it.name, thumb: it.thumb));
        }
      }
      this._context.toPage(
          VideoPlayerPage(dfsFileList: videoList, currentIndex: curentIndex));
    }
  }
}
