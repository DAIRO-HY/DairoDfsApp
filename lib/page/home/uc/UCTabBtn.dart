import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/Const.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import 'package:dairo_dfs_app/uc/UCButton.dart';

///导航切换按钮
class UCTabBtn extends StatelessWidget {
  static const HEIGHT = 50.0;

  ///文本文字
  final String text;

  ///图标
  final IconData icon;

  ///颜色
  Color color;

  ///标识
  final String tag;

  ///点击回调事件
  final void Function(String tag) onPressed;

  ///颜色值监听
  final ValueNotifier<Color> _colorNotify = ValueNotifier(Colors.grey);

  UCTabBtn({super.key, required this.text, required this.icon, required this.onPressed, required this.tag, this.color = Colors.grey});

  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Expanded(
        child: TextButton(
            onPressed: () {
              onPressed(tag);
            },
            style: TextButton.styleFrom(
              minimumSize: const Size(0, 0),
              // 选填：设置最小尺寸
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              // 选填：紧凑的点击目标尺寸
              padding: EdgeInsets.zero,
              //设置没有内边距
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0), // 设置圆角
              ),
              backgroundColor: context.color.primary,
            ),
            child: this._colorNotify.build((value) => SizedBox(
                height: UCTabBtn.HEIGHT,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(icon, color: value), Text(text, style: TextStyle(color: value, fontSize: Const.TEXT_SMALL))],
                ))))));
  }

  /// 设置选中状态
  ///
  /// [state] 选中状态
  void setSelected(bool state) {
    final color = state ? Colors.white : Color(0x40FFFFFF);
    _colorNotify.value = color;
  }
}
