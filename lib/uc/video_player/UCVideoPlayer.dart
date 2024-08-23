import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import 'package:dairo_dfs_app/uc/video_player/UCVideoPlayerBase.dart';

import 'UCAndroidIosMacVideoPlayer.dart';
import 'UCUnsuportVideoPlayer.dart';
import 'UCWindowsVideoPlayer.dart';

/// 视频播放页面
class UCAppVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;

  const UCAppVideoPlayer(this.controller,{super.key});

  @override
  State<UCAppVideoPlayer> createState() => _UCAppVideoPlayerState();
}

///视频播放器
class _UCAppVideoPlayerState extends State<UCAppVideoPlayer> {
  ///视频画面
  late UCVideoPlayerBase _videoView;

  ///当前播放状态
  ///var playState = VideoPlayerState.PAUSING;

  ///视频尺寸宽高比改变通知
  final _rateWhValueNotifer = ValueNotifier(2.0);

  ///播放器控制操作显示隐藏改变事件
  // final void Function(bool isVisible) _controllerVisibleChange;

  _UCAppVideoPlayerState() {
    if (Platform.isWindows) {
      //windows平台
      this._videoView = UCWindowsVideoPlayer();
    } else if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      //Android，IOS，MAC平台
      this._videoView = UCAndroidIosMacVideoPlayer();
    } else {
      this._videoView = UCUnsuportVideoPlayer();
    }

    ///设置初始化回调函数
    this._videoView.setInitCallback((size) {
      this._rateWhValueNotifer.value = size.width / size.height;
    });
  }

  @override
  void initState() {
    super.initState();

    //设置初始化函数
    this.widget.controller.setInitFunc((url) async {
      await this._videoView.init(url);
    });

    //设置播放函数
    this.widget.controller.setPlayFunc(() async {
      await this._videoView.play();
    });

    //设置暂停函数
    this.widget.controller.setPauseFunc(() async {
      await this._videoView.pause();
    });

    //获设置取进度函数
    this.widget.controller.setProgressFunc(() async {
      final progress = await this._videoView.getProgress();
      if (progress.current.toDouble() > progress.total.toDouble()) {
        print("-->progress.current:${progress.current}  progress.total:${progress.total}");

        //视频切换的时候有可能发生
        return UCProgressInfo(0, 0);
      }
      return progress;
    });

    //设置跳转函数
    this.widget.controller.setSeekToFunc((Duration position) async {
      await this._videoView.seekTo(position);
    });

    //设置销毁函数
    this.widget.controller.setDisposeFunc(() async {
      await this._videoView.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return this._rateWhValueNotifer.build((value) {
        //当前窗口宽高比
        final windowRateWh = constraints.maxWidth / constraints.maxHeight;
        final double width;
        final double height;

        if (value > windowRateWh) {
          //如果视频宽高比大于窗口的宽高比,则已窗口高度作为视频高度

          width = constraints.maxWidth;
          height = width / value;
        } else {
          height = constraints.maxHeight;
          width = height * value;
        }
        return Center(
            child: SizedBox(
          width: width,
          height: height,
          child: this._videoView, //视频画面显示
        ));
      });
    });
  }

  ///注销播放器
  @override
  void dispose() {
    super.dispose();
    this._videoView.dispose();
    print("-->播放器被销毁");
  }
}

///视频播放器控制器
class VideoPlayerController {
  ///初始化函数
  Future<void> Function(String url)? _initFunc;

  ///设置初始化函数
  void setInitFunc(Future<void> Function(String url)? func) {
    this._initFunc = func;
  }

  ///播放器初期化
  Future<void> init(String url) async {
    if (this._initFunc != null) {
      await this._initFunc!(url);
    }
  }

/*------------------------------------------------------------------------------------------------------------*/

  ///播放函数
  Future<void> Function()? _playFunc;

  ///设置播放函数
  void setPlayFunc(Future<void> Function() func) {
    this._playFunc = func;
  }

  ///播放
  Future<void> play() async {
    if (this._playFunc != null) {
      await this._playFunc!();
    }
  }

/*------------------------------------------------------------------------------------------------------------*/

  ///暂停函数
  Future<void> Function()? _pauseFunc;

  ///设置暂停函数
  void setPauseFunc(Future<void> Function() func) {
    this._pauseFunc = func;
  }

  ///暂停
  Future<void> pause() async {
    if (this._pauseFunc != null) {
      await this._pauseFunc!();
    }
  }

/*------------------------------------------------------------------------------------------------------------*/

  ///获取进度函数
  Future<UCProgressInfo> Function()? _getProgressFunc;

  ///设置获取进度函数
  void setProgressFunc(Future<UCProgressInfo> Function() func) {
    this._getProgressFunc = func;
  }

  ///获取进度
  Future<UCProgressInfo> getProgress() async {
    if (this._getProgressFunc != null) {
      return await this._getProgressFunc!();
    } else {
      return UCProgressInfo(0, 0);
    }
  }

/*------------------------------------------------------------------------------------------------------------*/

  ///跳到指定位置函数
  Future<void> Function(Duration position)? _seekToFunc;

  ///设置跳到指定位置函数
  void setSeekToFunc(Future<void> Function(Duration position) func) {
    this._seekToFunc = func;
  }

  ///跳到指定位置
  Future<void> seekTo(Duration position) async {
    if (this._seekToFunc != null) {
      await this._seekToFunc!(position);
    }
  }

/*------------------------------------------------------------------------------------------------------------*/

  ///销毁函数
  Future<void> Function()? _disposeFunc;

  ///设置销毁函数
  void setDisposeFunc(Future<void> Function() func) {
    this._disposeFunc = func;
  }

  ///销毁
  Future<void> dispose() async {
    if (this._disposeFunc != null) {
      await this._disposeFunc!();
    }
  }
}

enum VideoPlayerState {
  ///播放中
  PLAYING,

  ///暂停中
  PAUSING,
}
