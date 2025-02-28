import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/db/dao/DownloadDao.dart';
import 'package:dairo_dfs_app/db/dao/UploadDao.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';

import '../../../util/even_bus/EventCode.dart';
import '../../../util/even_bus/EventUtil.dart';
import '../../transfer/TransferPage.dart';
import '../AlbumPage.dart';

///文件列表页面顶部工具条
class UCAlbumToolBar extends StatefulWidget {
  ///文件页面状态对象
  final AlbumPageState albumPageState;

  const UCAlbumToolBar(this.albumPageState, {super.key});

  @override
  State<UCAlbumToolBar> createState() => _UCAlbumToolBarState();
}

class _UCAlbumToolBarState extends State<UCAlbumToolBar> {
  ///工具条高度
  static const _HEIGHT = 40.0;

  ///传输数据发生变化通知
  late ValueNotifier _transferVN = ValueNotifier(false);

  @override
  void initState() {
    super.initState(); // 无限重复动画

    //下载数据发生变化时
    EventUtil.regist(this, EventCode.DOWNLOAD_PAGE_RELOAD, (_) {
      this._getTransferCount();
    });

    //上传数据发生变化时
    EventUtil.regist(this, EventCode.UPLOAD_PAGE_RELOAD, (_) {
      this._getTransferCount();
    });
    this._getTransferCount();
  }

  ///获取传输文件数量
  void _getTransferCount() {
    final transerCount = DownloadDao.selectDownloadCount() + UploadDao.selectUploadCount();
    this._transferVN.value = transerCount > 0;
    // this._transferVN.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 5, top: 5),
        child: SafeArea(
            bottom: false,
            child: Row(children: [

              ///文件传输中标志
              this._transferVN.build((value) {
                return value ? UCTransferBtn() : SizedBox();
              }),
              Gap(5),
              this.widget.albumPageState.selectModeVN.build((value) {
                //图标
                IconData icon = value ? Icons.close : Icons.more_vert;
                return this.barBtnView(icon, onPressed: this.onCheckModelClick, me: 5);
              }),
              Gap(5),
            ])));
  }

  ///功能按钮
  Widget barBtnView(IconData icon, {required VoidCallback onPressed, double ms = 0.0, double me = 0.0}) {
    return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // 选填：紧凑的点击目标尺寸
          padding: EdgeInsets.zero,
          backgroundColor: Color(0x66000000),
          // 设置背景颜色
          //foregroundColor: context.color.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999), // 设置圆角
          ),
          minimumSize: Size(0, 0), // 设置宽度和高度
          //padding: EdgeInsets.zero, minimumSize: Size(0, 0)
        ),
        child: Container(
            // margin: EdgeInsets.only(left: ms, right: me),
            height: _HEIGHT,
            width: _HEIGHT,
            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(Const.RADIUS), color: context.color.primaryContainer),
            child: Icon(icon, color: Colors.white, size: 24)));
  }

  ///上级目录点击事件
  void onBackClick() {
    final folder = this.widget.albumPageState.currentFolderVN.value;
    if (folder.isEmpty) {
      return;
    }
    final lastSplitIndex = folder.lastIndexOf("/");
    final parentFolder = folder.substring(0, lastSplitIndex);
    this.widget.albumPageState.ucFileList.loadSubFile(parentFolder);
  }

  ///选择模式切换按钮点击事件
  void onCheckModelClick() {
    this.widget.albumPageState.selectModeVN.value = !this.widget.albumPageState.selectModeVN.value;
    if (!this.widget.albumPageState.selectModeVN.value) {
      //选择模式关闭的情况
      this.widget.albumPageState.ucOptionMenu.hide();
    } else {
      this.widget.albumPageState.ucOptionMenu.redraw();

      //文件列表重绘
      this.widget.albumPageState.ucFileList.redraw();
    }
  }

  @override
  void dispose() {
    super.dispose();
    EventUtil.unregist(this);
  }
}

///文件传输中标记
class UCTransferBtn extends StatefulWidget {
  const UCTransferBtn({super.key});

  @override
  State<UCTransferBtn> createState() => _UCTransferBtnState();
}

class _UCTransferBtnState extends State<UCTransferBtn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    this._controller = AnimationController(
      duration: const Duration(seconds: 2), // 动画持续时间
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          if (DownloadDao.selectDownloadCount() > 0) {
            context.toPage(TransferPage(pageTag: TransferPage.PAGE_DOWNLOAD));
          } else if (UploadDao.selectUploadCount() > 0) {
            context.toPage(TransferPage(pageTag: TransferPage.PAGE_UPLOAD));
          } else {
            context.toPage(TransferPage());
          }
        },
        style: TextButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // 选填：紧凑的点击目标尺寸
          padding: EdgeInsets.zero,
          backgroundColor: Color(0x66000000),
          // 设置背景颜色
          foregroundColor: context.color.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999), // 设置圆角
          ),
          minimumSize: Size(0, 0), // 设置宽度和高度
          //padding: EdgeInsets.zero, minimumSize: Size(0, 0)
        ),
        child: SizedBox(
          // margin: EdgeInsets.only(right: 10),
          height: _UCAlbumToolBarState._HEIGHT,
          width: _UCAlbumToolBarState._HEIGHT,
          // decoration: BoxDecoration(borderRadius: BorderRadius.circular(Const.RADIUS), color: context.color.primaryContainer),
          child: RotationTransition(
            turns: this._controller,
            child: Icon(
              Icons.sync,
              color: Colors.white,
              size: 24,
            ),
          ),
        ));
  }

  @override
  void dispose() {
    //动画控制器必须在State.dispose()之前调用,否则报错
    this._controller.dispose();
    super.dispose();
  }
}
