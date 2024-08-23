import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/page/transfer/download/DownloadPage.dart';
import 'package:dairo_dfs_app/page/transfer/upload/UploadPage.dart';
import '../transfer_set/TransferSetPage.dart';

/// 文件传输页面
class TransferPage extends StatefulWidget {

  ///下载页面标记
  static const PAGE_DOWNLOAD = 1;

  ///上传页面标记
  static const PAGE_UPLOAD = 2;

  ///页面标记
  final int pageTag;

  TransferPage({super.key, this.pageTag = TransferPage.PAGE_DOWNLOAD});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {

  ///页面标记
  late int pageTag = this.widget.pageTag;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final StatefulWidget page;
    if (this.pageTag == TransferPage.PAGE_DOWNLOAD) {
      page = DownloadPage();
    } else {
      page = UploadPage();
    }
    return Scaffold(
        body: Container(
            color: context.color.primaryContainer,
            child: Column(
              children: [
                this.titleBar,
                Gap(5),
                Expanded(child: page),
              ],
            )));
  }

  ///标题栏
  Container get titleBar => Container(
      color: context.color.primary,
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
                  Gap(5),
                  Expanded(child: Align(alignment: Alignment.center, child: this._switchBtn)),
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
                        context.toPage(TransferSetPage());
                      },
                      child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Center(
                              child: Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 24,
                          )))),
                  Gap(5),
                ],
              ),
              Gap(5),
            ])),
      ));

  ///页面选择按钮控件
  Widget get _switchBtn => SegmentedButton(
        showSelectedIcon: false,
        //不显示图标
        multiSelectionEnabled: false,
        //单选
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((state) {
            if (state.contains(WidgetState.selected)) {
              return Colors.white;
            } else {
              return context.color.primary;
            }
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>((state) {
            if (state.contains(WidgetState.selected)) {
              return context.color.primary;
            } else {
              return Colors.white;
            }
          }),
          // shadowColor: MaterialStateProperty.all(Colors.blue)
        ),
        segments: [ButtonSegment(value: 1, label: Text("下载"), enabled: true), ButtonSegment(value: 2, label: Text("上传"))],
        selected: {pageTag},
        onSelectionChanged: (Set<int> selected) {
          this.setState(() {
            this.pageTag = selected.first;
          });
        },
      );

  ///页面选择按钮控件
// Widget get _switchBtn {
//   final switchBtns = [_PageSwitchBtn("下载", 1), _PageSwitchBtn("上传", 2)].map((it) {
//     final Color bgColor;
//     if (this.pageTag == it.tag) {
//       bgColor = context.color.primary;
//     } else {
//       bgColor = BG_SWITCH_BTNS;
//     }
//     return Expanded(
//         child: UCButton(it.label, bgColor: bgColor, onPressed: () {
//           setState(() {
//             this.pageTag = it.tag;
//           });
//         }));
//   }).toList() as List<Widget>;
//   return Container(
//     margin: EdgeInsets.all(10),
//     padding: EdgeInsets.all(5),
//     decoration: BoxDecoration(color: BG_SWITCH_BTNS, borderRadius: BorderRadius.circular(Const.RADIUS)),
//     child: Row(
//       children: switchBtns,
//     ),
//   );
// }
}

class _PageSwitchBtn {
  final String label;
  final int tag;

  _PageSwitchBtn(this.label, this.tag);
}
