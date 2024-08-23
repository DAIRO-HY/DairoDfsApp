import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/uc/video_player/UCVideoPlayer.dart';

import 'Const.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State {
  final player = UCAppVideoPlayer(VideoPlayerController(),
  );

  @override
  initState() {
    super.initState();

    //页面加载完成之后回调事件
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await this.player.videoView.init("${Const.DOMAIN}/app/files/download/trailer.mp4?folder=&_token=310e621bf2bbebe8008bc5145d051f9d");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: this.player),
    );
  }
}
