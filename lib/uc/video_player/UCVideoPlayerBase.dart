import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///视频播放器
abstract class UCVideoPlayerBase extends StatelessWidget {
  ///初始换完成会带哦函数
  void Function(Size size)? initFun;

  ///播放器初始化
  Future<void> init(String url);

  ///播放
  Future<void> play();

  ///暂停
  Future<void> pause();

  ///跳到指定播放位置
  Future<void> seekTo(Duration position);

  ///注销播放器
  Future<void> dispose();

  Future<UCProgressInfo> getProgress();

  ///设置初始化回调函数
  void setInitCallback(void Function(Size size) func){
    this.initFun = func;
  }
}

///视频播放器播放进度信息
class UCProgressInfo {
  ///得到视频总时长
  final int total;

  ///当前播放未知
  final int current;
  UCProgressInfo(this.total,this.current);
}
