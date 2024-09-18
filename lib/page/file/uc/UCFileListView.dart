import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/code/FileOrderBy.dart';
import 'package:dairo_dfs_app/code/FileSortType.dart';
import 'package:dairo_dfs_app/code/FileViewType.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/String++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import 'package:dairo_dfs_app/page/image_viewer/ImageViewerPage.dart';
import 'package:dairo_dfs_app/page/video_player/VideoPlayerPage.dart';

import '../../../api/model/FileModel.dart';
import '../../../util/shared_preferences/SettingShared.dart';
import '../bean/DfsFileBean.dart';
import '../../../util/shared_preferences/DfsFileShared.dart';
import '../FilePage.dart';
import 'UCFileItem.dart';

///文件列表组件
class UCFileListView extends StatelessWidget {
  ///文件列表改变监听器
  final fileListFlagVN = ValueNotifier(0);

  ///文件页面状态对象
  final FilePageState filePageState;

  List<DfsFileBean> dfsFileList = [];

  late BuildContext _context;

  UCFileListView(this.filePageState, {super.key});

  @override
  Widget build(BuildContext context) {
    this._context = context;
    return Expanded(
        child: Container(
            color: context.color.primaryContainer,
            child: this.fileListFlagVN.build((value) {
              final viewType = SettingShared.viewType;
              final Widget itemGroupView;
              if (viewType == FileViewType.LIST) {
                //列表显示
                itemGroupView = ListView.builder(
                    padding: EdgeInsets.zero, //消除SafeArea的内边距
                    itemCount: this.dfsFileList.length,
                    itemBuilder: (context, index) {
                      final dfsFile = this.dfsFileList[index];

                      //文件列表条目
                      return fileItemView(dfsFile, viewType);
                    });
              } else {
                //表格显示
                itemGroupView = GridView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: this.dfsFileList.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 120.0, // 每个项的最大宽度
                      childAspectRatio: 4 / 5, // 宽高比
                      crossAxisSpacing: 10.0, // 水平间距
                      mainAxisSpacing: 10.0, // 垂直间距
                    ),
                    itemBuilder: (context, index) {
                      final dfsFile = this.dfsFileList[index];

                      //文件列表条目
                      return fileItemView(dfsFile, viewType);
                    });
              }
              return itemGroupView;
            })));
  }

  ///文件项目
  Widget fileItemView(DfsFileBean dfsFile, int viewType) => Listener(
      onPointerDown: (PointerDownEvent event) {
        if (event.kind == PointerDeviceKind.mouse && event.buttons == kSecondaryMouseButton) {
          // 处理右键点击事件
          for (final it in this.dfsFileList) {
            //右键点击时，默认只选择当前文件
            it.isSelected = false;
          }
          this.filePageState.selectModeVN.value = true;
          dfsFile.isSelected = true;
          this.filePageState.selectedCount = 1;
          this.filePageState.ucOptionMenu.redraw();
          this.redraw();
        }
      },
      child: UCFileItem(
        dfsFile,
        viewType,
        isSelectMode: this.filePageState.selectModeVN.value,
        onSelectChange: this.filePageState.onCheckChange,
        onLoadSubFile: this.loadSubFile,
        onFileClick: this.onFileClick,
      ));

  ///当前选中的路径列表
  List<String> get selectedPaths => this.dfsFileList.where((it) => it.isSelected).map((it) => it.path).toList();

  ///当前选中的路径列表
  List<DfsFileBean> get selected => this.dfsFileList.where((it) => it.isSelected).toList();

  ///获取文件列表
  void loadSubFile(String folderPath) {
    DfsFileShared.getSubList(folderPath, (list) {
      if (this.filePageState.isFinish) {
        //如果页面已经关闭，那就什么也不做。防止异步操作时，页面被关闭报错
        return;
      }
      this.sortFile(list);
      this.dfsFileList = list.map((it) => DfsFileBean(folderPath, it)).toList();
      this.filePageState.selectedCount = 0;

      //关闭选择模式
      //this.filePageState.selectModeVN.value = false;

      //设置当前显示的文件夹路径
      this.filePageState.currentFolderVN.value = folderPath;

      //记录当前打开的文件夹
      SettingShared.lastOpenFolder = folderPath;

      //隐藏操作菜单栏
      //this.filePageState.ucOptionMenu.hide();

      //重回文件页面
      this.redraw();
    });
  }

  ///文件排列
  void sortFile(List<FileModel> dfsList) {
    //排序方式
    final sortType = SettingShared.sortType;

    //升降序方式
    final sortOrderBy = SettingShared.sortOrderBy;

    //排序
    dfsList.sort((p1, p2) {
      final int compareValue;
      if (sortType == FileSortType.NAME) {
        compareValue = p1.name.toLowerCase().compareTo(p2.name.toLowerCase());
      } else if (sortType == FileSortType.DATE) {
        compareValue = p1.date.compareTo(p2.date);
      } else if (sortType == FileSortType.SIZE) {
        compareValue = p1.size.compareTo(p2.size);
      } else if (sortType == FileSortType.EXT) {
        compareValue = p1.name.fileExt.toLowerCase().compareTo(p2.name.fileExt.toLowerCase());
      } else {
        return 0;
      }
      if (sortOrderBy == FileOrderBy.UP) {
        //升降序方式
        return compareValue;
      }
      return compareValue * -1;
    });

    //使文件夹始终在最上面
    dfsList.sort((p1, p2) {
      if (p1.fileFlag && !p2.fileFlag) {
        //都是文件夹
        return 1;
      } else if (!p1.fileFlag && p2.fileFlag) {
        //都是文件夹
        return -1;
      } else {
        return 0;
      }
    });
  }

  ///重绘页面
  void redraw() {
    this.fileListFlagVN.value = this.fileListFlagVN.value++;
  }

  ///重新加载文件列表
  void reload() {
    this.loadSubFile(this.filePageState.currentFolderVN.value);
  }

  ///文件点击事件
  void onFileClick(DfsFileBean dfsFile) {
    //是否图片
    isImageFun(String name) =>
        name.endsWith(".jpg") ||
        name.endsWith(".jpeg") ||
        name.endsWith(".png") ||
        name.endsWith(".jfif") ||
        name.endsWith(".psd") ||
        name.endsWith(".psb") ||
        name.endsWith(".cr3") ||
        name.endsWith(".cr2");

    //是否视频
    isVedio(String name) => name.endsWith(".mp4") || name.endsWith(".mov");
    if (isImageFun(dfsFile.name.toLowerCase())) {
      //如果是图片的话

      //整理所有图片列表
      final imageList = <DfsFileBean>[];

      //当前选择的序号
      var curentIndex = -1;
      for (var i = 0; i < this.dfsFileList.length; i++) {
        final it = this.dfsFileList[i];
        if (it == dfsFile) {
          curentIndex = imageList.length;
        }
        if (isImageFun(it.name.toLowerCase())) {
          imageList.add(it);
        }
      }
      this._context.toPage(ImageViewerPage(dfsFileList: imageList, currentIndex: curentIndex));
    } else if (isVedio(dfsFile.name.toLowerCase())) {
      //如果是视频的话

      //整理所有视频列表
      final videoList = <DfsFileBean>[];

      //当前选择的序号
      var curentIndex = -1;
      for (var i = 0; i < this.dfsFileList.length; i++) {
        final it = this.dfsFileList[i];
        if (it == dfsFile) {
          curentIndex = videoList.length;
        }
        if (isVedio(it.name.toLowerCase())) {
          videoList.add(it);
        }
      }
      this._context.toPage(VideoPlayerPage(dfsFileList: videoList, currentIndex: curentIndex));
    }
  }
}
