import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/Const.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import 'package:dairo_dfs_app/page/home/HomePage.dart';
import 'package:dairo_dfs_app/util/SyncVariable.dart';
import 'package:dairo_dfs_app/util/shared_preferences/SettingShared.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SyncVariable.init(() {
    runApp(const MyApp());

    // "UPLOAD_LOCAL_KEY".toLocalObj(null);
    // "DOWNLOAD_LOCAL_KEY".toLocalObj(null);

    //开启上传任务
    //UploadTask.start();
    //DownloadTask.start();
  });
  //runApp(const MyApp());
}

const Set<PointerDeviceKind> _kTouchLikeDeviceTypes = <PointerDeviceKind>{
  PointerDeviceKind.touch,
  PointerDeviceKind.mouse,
  PointerDeviceKind.stylus,
  PointerDeviceKind.invertedStylus,
  PointerDeviceKind.unknown
};

class MyApp extends StatelessWidget {
  ///主题变更通知
  static final themeVn = ValueNotifier(SettingShared.theme);

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return themeVn.build((value) {

      //主题模式
      var themeMode = ThemeMode.system;
      switch (value) {
        case 1:
          themeMode = ThemeMode.light;
          break;
        case 2:
          themeMode = ThemeMode.dark;
          break;
      }
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        // theme: ThemeData.dark(),
        theme: this.light,
        darkTheme: this.dart,
        themeMode: themeMode,
        scrollBehavior: const MaterialScrollBehavior().copyWith(scrollbars: true, dragDevices: _kTouchLikeDeviceTypes),
        // home: const Text("12345"),
        home: const HomePage(),
      );
    });
  }

  ///明亮主题
  ThemeData get light {
    //主调色
    const primary = Color(0xFF133641);

    return ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(backgroundColor: primary, foregroundColor: Colors.white),
        dialogTheme: DialogTheme(

            //对话框的背景颜色。
            backgroundColor: Colors.white,

            //对话框的阴影高度。
            elevation: 20,

            //阴影颜色
            shadowColor: Colors.black,

            //对话框标题的文本样式。
            titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),

            //对话框内容的文本样式。
            contentTextStyle: TextStyle(color: Colors.black, fontSize: Const.TEXT),

            //对话框中 actions 部分的填充。
            actionsPadding: EdgeInsets.all(0)),
        colorScheme: const ColorScheme(
            brightness: Brightness.light,

            //应用的主要颜色，用于强调重要的元素，如按钮、活动栏等。
            primary: primary,

            // primary 颜色上的文本和图标颜色，以确保足够的对比度。
            onPrimary: Colors.white,

            //主要容器颜色，用于比 primary 颜色对比度较低的背景。
            primaryContainer: Colors.white,

            // primaryContainer 颜色上的文本和图标颜色。
            onPrimaryContainer: Colors.white,

            //应用的次要颜色，用于强调次要的元素，如浮动操作按钮等。
            secondary: Color(0xff676767),

            //secondary 颜色上的文本和图标颜色。
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            shadow: Colors.yellow,

            //应用的背景颜色，通常用于应用的主要内容区域。
            surface: Color(0xffd3d3d3),

            // surface 颜色上的文本和图标颜色
            onSurface: Colors.black,

            //轮廓颜色，用于组件的边框，如输入框的边框。
            outline: Color(0x10000000)));
  }

  ///黑暗主题
  ThemeData get dart {
    //主调色
    const primary = Color(0xFF0B1F25);
    return ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(backgroundColor: primary, foregroundColor: Colors.white),
        dialogTheme: DialogTheme(

            //对话框的背景颜色。
            backgroundColor: Color(0xff373737),

            //对话框的阴影高度。
            elevation: 20,

            //阴影颜色
            shadowColor: Color(0xFF3E3E3E),

            //对话框标题的文本样式。
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),

            //对话框内容的文本样式。
            contentTextStyle: TextStyle(color: Colors.white, fontSize: Const.TEXT),

            //对话框中 actions 部分的填充。
            actionsPadding: EdgeInsets.all(0)),
        colorScheme: const ColorScheme(
            brightness: Brightness.dark,

            //应用的主要颜色，用于强调重要的元素，如按钮、活动栏等。
            primary: primary,

            // primary 颜色上的文本和图标颜色，以确保足够的对比度。
            onPrimary: Colors.white,

            //主要容器颜色，用于比 primary 颜色对比度较低的背景。
            primaryContainer: Color(0xff2c2c2c),

            // primaryContainer 颜色上的文本和图标颜色。
            onPrimaryContainer: Colors.white,

            //应用的次要颜色，用于强调次要的元素，如浮动操作按钮等。
            secondary: Color(0xffb8b8b8),

            //secondary 颜色上的文本和图标颜色。
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            shadow: Colors.yellow,

            //应用的背景颜色，通常用于应用的主要内容区域。
            surface: Color(0xFF1B1B1B),

            // surface 颜色上的文本和图标颜色
            onSurface: Colors.white,

            //轮廓颜色，用于组件的边框，如输入框的边框。
            outline: Color(0x10FFFFFF)));
  }
}
