import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import 'package:video_player_win/video_player_win.dart';
import 'UCVideoPlayerBase.dart';

///windows平台的视频播放器
class UCWindowsVideoPlayer extends UCVideoPlayerBase {
  ///标记播放器是否已经初始化
  var isInit = false;

  ///播放器控制器初始值监听
  final initedValueNotify = ValueNotifier<WinVideoPlayerController?>(null);

  ///播放器控制器
  WinVideoPlayerController? videoPlayerController;

  ///播放器初始化
  @override
  Future<void> init(String url) async {
    if (this.isInit) {
      //如果已经初始化过了，则把上次的播放器注销掉
      this.videoPlayerController!.dispose();
    }
    if(url.startsWith("http")){

      //从网络连接播放
      this.videoPlayerController = WinVideoPlayerController.network(url);
    }else{

      //从本地文件播放
      this.videoPlayerController = WinVideoPlayerController.file(File(url));
    }
    await this.videoPlayerController!.initialize();

    //得到视频尺寸
    final size = this.videoPlayerController!.value.size;
    if (super.initFun != null) {
      super.initFun!(size);
    }
    this.initedValueNotify.value = this.videoPlayerController;
    this.isInit = true;
  }

  ///播放
  @override
  Future<void> play() async {
    await this.videoPlayerController?.play();
  }

  ///暂停
  @override
  Future<void> pause() async {
    await this.videoPlayerController?.pause();
  }

  ///跳到指定播放位置
  @override
  Future<void> seekTo(Duration position) async {
    await this.videoPlayerController?.seekTo(position);
  }

  ///注销播放器
  @override
  Future<void> dispose() async {
    await this.videoPlayerController?.dispose();
    this.videoPlayerController = null;
  }

  @override
  Future<UCProgressInfo> getProgress() async {
    if (this.videoPlayerController == null) {
      return UCProgressInfo(0, 0);
    }

    //得到视频总时长
    final total = this.videoPlayerController!.value.duration;

    //当前播放未知
    final current = await this.videoPlayerController!.position ?? Duration(microseconds: 0);
    return UCProgressInfo(total.inMilliseconds, current.inMilliseconds);
  }

  @override
  Widget build(BuildContext context) {
    return this.initedValueNotify.build((value) {
      if (value == null) {
        return SizedBox();
      }
      return WinVideoPlayer(value);
    });
  }
}
