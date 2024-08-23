import 'package:flutter/cupertino.dart';
import 'UCVideoPlayerBase.dart';

///不支持的平台的视频播放器
class UCUnsuportVideoPlayer extends UCVideoPlayerBase {
  ///播放器初始化
  @override
  Future<void> init(String url) async {}

  ///播放
  @override
  Future<void> play() async {}

  ///暂停
  @override
  Future<void> pause() async {}

  @override
  Future<void> seekTo(Duration position) async {}

  ///注销播放器
  Future<void> dispose() async {}

  @override
  Widget build(BuildContext context) {
    return Text("不支持的平台");
  }

  @override
  Future<UCProgressInfo> getProgress() async {
    return UCProgressInfo(0, 0);
  }
}
