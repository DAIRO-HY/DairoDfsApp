import 'package:flutter/material.dart';
import '../Const.dart';
import '../util/Toast.dart';

extension BuildContextExtension on BuildContext {
  ///主题颜色
  ColorScheme get color =>
      Theme
          .of(this)
          .colorScheme;

  ///普通文字文字
  Widget textBody(String? txt, {Color? color}) {
    if (txt == null) {
      return SizedBox();
    }
    color ??= this.color.onSurface;
    return Text(txt, style: TextStyle(color:color, fontSize: Const.TEXT));
  }

  ///小文字文字文字
  Widget textSmall(String? txt, {Color? color}) {
    if (txt == null) {
      return SizedBox();
    }
    color ??= this.color.onSurface;
    return Text(txt, style: TextStyle(color:color, fontSize: Const.TEXT_SMALL));
  }

  ///次要小文字
  Widget textSecondarySmall(String? txt) {
    if (txt == null) {
      return SizedBox();
    }
    return Text(txt, style: TextStyle(color: this.color.secondary, fontSize: Const.TEXT_SMALL));
  }

  ///页面跳转
  void toPage(StatefulWidget page) {
    Navigator.push(this, MaterialPageRoute(builder: (context) => page));
  }

  ///页面跳转
  void relaunch(StatefulWidget page) =>
      Navigator.pushAndRemoveUntil(this, MaterialPageRoute(builder: (context) => page), (Route<dynamic> route) => false);

  ///气泡提示消息
  void toast(String msg) => Toast.show(this, msg);

  ///文字按钮
  Widget textButton(String text, {VoidCallback? onPressed}) =>
      TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            overlayColor: Colors.transparent,
            minimumSize: const Size(0, 0),
            // 选填：设置最小尺寸
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            // 选填：紧凑的点击目标尺寸
            padding: EdgeInsets.zero,
            //设置没有内边距
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0), // 设置圆角
            ),
            backgroundColor: Colors.transparent,
          ),
          child: this.textBody(text));
}
