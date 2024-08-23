import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/Number++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import 'package:dairo_dfs_app/util/download/DownloadTask.dart';
import '../../../../Const.dart';
import '../../../../db/dao/DownloadDao.dart';
import '../../../../uc/UCImage.dart';
import '../../../../util/download/DownloadBridge.dart';
import '../../../../util/even_bus/EventCode.dart';
import '../../../../util/even_bus/EventUtil.dart';
import 'UCDownloadInfoDialog.dart';

///下载列表详细信息组件
class UCDownloadItem extends StatelessWidget {
  ///文件下载信息
  final DownloadBridge bridge;

  ///当前上下文
  late BuildContext _context;

  ///是否被选中图标更新
  final selectedVN = ValueNotifier(0);

  ///选择状态发生改变事件
  final void Function(bool flag) onSelectChange;

  ///当前选中的Id列表
  final HashSet<int> selectedIds;

  ///点击回调事件
  UCDownloadItem(this.bridge, {required this.selectedIds, required this.onSelectChange});

  @override
  Widget build(BuildContext context) {
    this._context = context;
    return TextButton(
        style: TextButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // 选填：紧凑的点击目标尺寸
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999), // 设置圆角
          ),
          minimumSize: Size.zero, // 设置宽度和高度
        ),
        onPressed: () {
          bool isSelected;
          if (this.selectedIds.contains(this.bridge.dto.id)) {
            //如果当前为选中状态，则标记为非选中
            this.selectedIds.remove(this.bridge.dto.id);
            isSelected = false;
          } else {
            //如果当前为非选中状态，则标记为选中
            this.selectedIds.add(this.bridge.dto.id);
            isSelected = true;
          }
          this.selectedVN.value++;
          this.onSelectChange(isSelected);
        },
        child: Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: context.color.primaryContainer,
            ),
            child: Row(
              children: [
                this.checkIconView,
                this.thumbView,
                Gap(5),
                Expanded(
                    child: Column(children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: context.textBody(this.bridge.dto.name),
                  ),
                  this._linearProgress,
                  Row(children: [this._uploadedInfo, Spacer(), this._stateInfo])
                ])),
                TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // 选填：紧凑的点击目标尺寸
                      padding: EdgeInsets.zero,
                      // 设置背景颜色
                      foregroundColor: context.color.primary,
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(999999), // 设置圆角
                      // ),
                      minimumSize: Size(40, 40), // 设置宽度和高度
                    ),
                    onPressed: this.onStateIconClick,
                    child: this._stateIcon),
                Gap(5)
              ],
            )));
  }

  ///选择图标
  Widget get checkIconView => this.selectedVN.build((value) {
        final isChecked = this.selectedIds.contains(this.bridge.dto.id);
        return SizedBox(
            width: 40,
            child: Opacity(
                opacity: isChecked ? 1 : 0.2,
                child: Icon(
                  isChecked ? Icons.check_circle : Icons.circle_outlined,
                  color: this._context.color.onSurface,
                  size: 20,
                )));
      });

  ///文件图标
  Widget get thumbView {
    if (this.bridge.dto.thumb == null) {
      //如果没有缩略图
      return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: this._context.color.onSurface.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                // offset: Offset(2, 2),
              ),
            ],
          ),
          child: Icon(Icons.insert_drive_file, color: Colors.white, size: 40));
    } else {
      return UCImage(this.bridge.dto.thumb!, width: 40, height: 40, radius: Const.RADIUS, checkedDownload: false);
    }
  }

  ///下载大小实时显示文本
  Widget get _uploadedInfo {
    if (this.bridge.dto.state == 10) {
      //文件已经下载完成,直接显示文件大小
      return this._context.textSecondarySmall(this.bridge.dto.size.dataSize);
    } else {
      return this._context.textSecondarySmall("${this.bridge.dto.downloadedSize.dataSize}/${this.bridge.dto.size.dataSize}");
    }
  }

  ///下载进度条
  Widget get _linearProgress => this.bridge.dto.state == 10
      ? const SizedBox()
      : LinearProgressIndicator(value: this.bridge.progress, minHeight: 2, backgroundColor: this._context.color.onSurface, color: Colors.lightGreen);

  ///下载状态图标
  Widget get _stateIcon {
    switch (this.bridge.dto.state) {
      case 0:
      case 1:
        return Icon(Icons.pause_circle_outline, color: this._context.color.onSurface);
      case 2: //暂停中
      case 3: //出错中
        return Icon(Icons.download_for_offline_outlined, color: this._context.color.onSurface);
      case 10: //完成
        return Icon(Icons.info_outline, color: this._context.color.onSurface);
    }
    return SizedBox();
  }

  ///状态图标点击事件
  void onStateIconClick() {
    this.bridge.dto.msg = null; //清空消息
    switch (this.bridge.dto.state) {
      case 0: //等待中的任务
        DownloadDao.setState(this.bridge.dto.id, 2);
      case 1: //正在下载
        this.bridge.pause();
        return;
      case 2: //暂停中
        DownloadDao.setState(this.bridge.dto.id, 0);
        DownloadTask.start();
      case 3: //下载失败
        DownloadDao.setState(this.bridge.dto.id, 0);
        DownloadTask.start();
      case 10: //下载完成
        this.showDownloadDetail();
        return;
      default:
        return;
    }

    //通知刷新页面
    EventUtil.post(EventCode.DOWNLOAD_PROGRESS);
  }

  ///显示下载详细
  void showDownloadDetail() {
    UCDownloadInfoDialog.show(this._context, this.bridge.dto);
  }

  ///状态信息
  Widget get _stateInfo {
    var stateInfo = "";
    if (this.bridge.dto.state == 0) {
      //等待中的任务
      stateInfo = "排队中";
    } else if (this.bridge.dto.state == 1) {
      //正在下载
      stateInfo = this.bridge.dto.msg ?? "";
    } else if (this.bridge.dto.state == 2) {
      //暂停中
      stateInfo = "暂停中";
    } else if (this.bridge.dto.state == 3) {
      //失败
      return this._context.textSmall(this.bridge.dto.msg, color: this._context.color.error);
    } else if (this.bridge.dto.state == 10) {
      //下载完成
    } else {}
    return this._context.textSecondarySmall(stateInfo);
  }
}
