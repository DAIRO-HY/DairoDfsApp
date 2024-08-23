import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/db/dao/DownloadDao.dart';
import 'package:dairo_dfs_app/db/dao/UploadDao.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';

import '../../../util/even_bus/EventCode.dart';
import '../../../util/even_bus/EventUtil.dart';
import '../../transfer/TransferPage.dart';
import '../FilePage.dart';

///文件列表页面顶部工具条
class UCFileToolBar extends StatefulWidget {
  ///文件页面状态对象
  final FilePageState filePageState;

  const UCFileToolBar(this.filePageState, {super.key});

  @override
  State<UCFileToolBar> createState() => _UCFileToolBarState();
}

class _UCFileToolBarState extends State<UCFileToolBar> {
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
        color: context.color.primary,
        // color: Colors.red,
        padding: EdgeInsets.only(bottom: 5,top: 5),
        child: SafeArea(
            bottom: false,
            child: Row(children: [
              Gap(5),
              //上级目录按钮
              this.widget.filePageState.currentFolderVN.build((value) {
                if (value.isEmpty) {
                  return SizedBox();
                }
                return this.barBtnView(Icons.arrow_back, onPressed: this.onBackClick);
              }),

              Gap(5),

              //根目录按钮
              this.widget.filePageState.currentFolderVN.build((value) {
                if (value.isEmpty) {
                  return SizedBox();
                }
                return this.barBtnView(Icons.home, onPressed: () {
                  this.widget.filePageState.ucFileList.loadSubFile("");
                });
              }),
              Gap(10),
              Expanded(
                  child: Container(
                // margin: EdgeInsets.only(left: 10, right: 10),
                // padding: EdgeInsets.only(left: 10, right: 10),
                height: _HEIGHT,
                // decoration: BoxDecoration(borderRadius: BorderRadius.circular(Const.RADIUS), color: context.color.primaryContainer),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: this.widget.filePageState.currentFolderVN.build((value) {
                      //当前文件夹
                      return Text(value.isEmpty ? "根目录" : value, style: TextStyle(color: Colors.white, fontSize: 18));
                      // context.textBody(value.isEmpty ? "根目录" : value, color: Colors.white, size: 18);
                    })),
              )),
              Gap(5),

              ///文件传输中标志
              this._transferVN.build((value) {
                return value ? UCTransferBtn() : SizedBox();
              }),
              Gap(5),
              this.widget.filePageState.selectModeVN.build((value) {
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
    final folder = this.widget.filePageState.currentFolderVN.value;
    if (folder.isEmpty) {
      return;
    }
    final lastSplitIndex = folder.lastIndexOf("/");
    final parentFolder = folder.substring(0, lastSplitIndex);
    this.widget.filePageState.ucFileList.loadSubFile(parentFolder);
  }

  ///选择模式切换按钮点击事件
  void onCheckModelClick() {
    this.widget.filePageState.selectModeVN.value = !this.widget.filePageState.selectModeVN.value;
    if (!this.widget.filePageState.selectModeVN.value) {
      //选择模式关闭的情况
      for (var it in this.widget.filePageState.ucFileList.dfsFileList) {
        it.isSelected = false;
      }
      this.widget.filePageState.selectedCount = 0;
      this.widget.filePageState.ucOptionMenu.hide();
    } else {
      this.widget.filePageState.ucOptionMenu.redraw();
    }
    this.widget.filePageState.ucFileList.redraw();
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
          height: _UCFileToolBarState._HEIGHT,
          width: _UCFileToolBarState._HEIGHT,
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
