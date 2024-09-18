import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/Const.dart';
import 'package:dairo_dfs_app/api/FilesApi.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/Number++.dart';
import 'package:dairo_dfs_app/extension/String++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import 'package:dairo_dfs_app/page/file/bean/DfsFileBean.dart';
import 'package:dairo_dfs_app/util/shared_preferences/SettingShared.dart';
import '../../code/VideoQualityCode.dart';
import '../../db/dao/DownloadDao.dart';
import '../../db/dto/DownloadDto.dart';
import '../../uc/UCOptionMenuButton.dart';
import '../../uc/video_player/UCVideoPlayer.dart';
import '../../uc/video_player/UCVideoPlayerBase.dart';
import '../../util/download/DownloadTask.dart';
import '../../util/http/ApiHttp.dart';

/// 视频播放页面
class VideoPlayerPage extends StatefulWidget {
  ///当前浏览文件列表
  final List<DfsFileBean> dfsFileList;

  final int currentIndex;

  ///初始化跳转到指定播放位置
  final int seekTo;

  const VideoPlayerPage({super.key, required this.dfsFileList, required this.currentIndex, this.seekTo = 0});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  ///PageView控制器
  late final PageController _pageController = PageController(initialPage: this.widget.currentIndex);

  // ///当前浏览文件列表
  // final List<DfsFileBean> dfsFileList;
  //
  // ///当前播放的索引
  // int currentIndex;

  late int currentIndex = this.widget.currentIndex;

  ///文件名变化通知
  final nameVN = ValueNotifier("");

  ///播放进度变更通知
  final _progressVN = ValueNotifier(UCProgressInfo(0, 0));

  ///播放画质变化通知
  final qualityVN = ValueNotifier(SettingShared.videoQuality);

  ///播放控制按钮显示通知
  final _controllerVisibleVN = ValueNotifier(true);

  ///初始化完成通知
  final _initedVN = ValueNotifier(false);

  ///播放状态值改变通知
  final _playStateVN = ValueNotifier(VideoPlayerState.PAUSING);

  ///播放进度计时器
  Timer? _progressTimer;

  ///用来记录控制器按钮显示的事件
  var _controllerVisibleTimes = 0;

  final videoController = VideoPlayerController();

  ///得到当前DFS文件
  DfsFileBean get currentDfs => this.widget.dfsFileList[this.currentIndex];

  ///用来存储视频画质列表的keys
  String get qualityLocalKey => "${this.currentDfs.id}/video_extra";

  ///当前视频画质列表
  List<int>? get qualityKeys => this.qualityLocalKey.localObj((it) => List<int>.from(jsonDecode(it)));

  ///初始化跳转到指定播放位置
  late int _seekTo = this.widget.seekTo;

  ApiHttp? http;

  @override
  void initState() {
    super.initState();

    //页面加载完成之后回调事件
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await this.getExtras();
    });
  }

  ///获取画质列表
  Future<void> getExtras() async {
    //标记未初始化
    this._initedVN.value = false;

    //停止计时器
    this._stopTimer();

    //当前选中的文件
    final dfs = this.currentDfs;
    if (this.qualityKeys != null) {
      //如果该视频的画质列表已经加载过来
      await initPlayer();
    }
    this.http?.cancel();
    final http = FilesApi.getExtraKeys(id: dfs.id);
    http.post((value) async {
      final keys = value.where((it)=>it != "thumb").map((it) => int.parse(it)).toList();
      keys.sort((p1, p2) {
        if (p1 == p1) {
          return 0;
        }
        if (p1 > p2) {
          return 1;
        } else {
          return -1;
        }
      });
      this.qualityLocalKey.toLocalObj(keys);

      //如果视频还开始播放
      if (!this._initedVN.value) {
        await initPlayer();
      }
    });
    this.http = http;
  }

  ///初始化播放器
  Future<void> initPlayer() async {
    this.nameVN.value = this.currentDfs.name;

    ///标记为暂停状态
    this._playStateVN.value = VideoPlayerState.PAUSING;
    String? url;
    final downloadDto = DownloadDao.selectOneByUrlAndFinish(this._previewUrl);

    //先看这个文件有没有被下载
    if(downloadDto != null){
      final file = File(downloadDto.path);
      if(file.existsSync()){
        url = downloadDto.path;
      }
    }
    url ??= this._previewUrl.domainUrl;
    await this.videoController.init(url);

    if (this._seekTo != 0) {
      this.videoController.seekTo(Duration(milliseconds: this._seekTo));
      this._seekTo = 0;
    }

    //初始化完成之后立即播放
    await this.onPlayClick();
    this.qualityVN.value = this._bestQuality;

    //标记初始化完成
    this._initedVN.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      PageView.builder(
          itemCount: this.widget.dfsFileList.length,
          controller: this._pageController,
          onPageChanged: (index) async {
            print("-->onPageChanged:$index");
            await this.getExtras();
          },
          itemBuilder: (context, index) {
            print("-->itemBuilder:$index");
            this.currentIndex = index;

            //这里的url的content-type必须指定，否则可能导致无法播放
            return Container(color: Colors.black, child: UCAppVideoPlayer(this.videoController));
          }),

      //透明遮罩层
      this.shadeView,
      this._controllerVisibleVN.build((value) => Visibility(visible: value, child: this.titleBar)),

      //视频控制按钮等
      this.controllerView,

      //初始化等待框
      this._initedVN.build((value) => Visibility(
          visible: !value,
          child: Center(child: SizedBox(width: 60, height: 60, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)))))
    ]));
  }

  ///标题栏
  Container get titleBar => Container(
      color: Color(0x44000000),
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
                  Expanded(
                      child: Align(
                          alignment: Alignment.center,
                          child: this.nameVN.build((value) => Text(
                                value,
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              )))),
                  Gap(45)
                ],
              ),
              Gap(5),
            ])),
      ));

  ///透明遮罩层
  Widget get shadeView => GestureDetector(onTap: () {
        this._controllerVisibleTimes = 0;
        this._controllerVisibleVN.value = !this._controllerVisibleVN.value;
      });

  ///视频控制按钮等
  Widget get controllerView => this._controllerVisibleVN.build((value) {
        if (!value) {
          return SizedBox();
        } else {
          return Stack(children: [
            Center(
                child: SizedBox(
                    width: 300,
                    child: Row(children: [
                      Gap(10),
                      this.seekToView(Icons.rotate_left, -15000),
                      Spacer(),
                      this.btnPlayView,
                      Spacer(),
                      this.seekToView(Icons.rotate_right, 15000),
                      Gap(10)
                    ]))),
            Column(children: [
              Spacer(),
              Container(
                  color: Color(0x44000000),
                  child: SafeArea(
                      top: false,
                      child: Column(children: [
                        this._progressVN.build((value) {
                          if (value.current.toDouble() > value.total.toDouble()) {
                            print("-->value.current:${value.current}  value.total:${value.total}");
                          }

                          return Row(children: [
                            Expanded(
                                child: Slider(
                                    value: value.current.toDouble(),
                                    min: 0,
                                    max: value.total.toDouble(),
                                    onChangeStart: (before) {
                                      this._stopTimer();
                                    },
                                    onChangeEnd: (after) {
                                      this._startTimer();
                                      this.videoController.seekTo(Duration(milliseconds: after.toInt()));
                                    },
                                    onChanged: (newValue) {
                                      this._progressVN.value = UCProgressInfo(value.total, newValue.toInt());
                                    })),
                            context.textSmall("${value.current.timeFormat}/${value.total.timeFormat}", color: Colors.white),
                            Gap(20),
                            TextButton(
                                style: TextButton.styleFrom(
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  // 选填：紧凑的点击目标尺寸
                                  padding: EdgeInsets.zero,
                                  backgroundColor: Color(0xff000000),
                                  // 设置背景颜色
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999999), // 设置圆角
                                  ),
                                  minimumSize: Size(0, 0), // 设置宽度和高度
                                ),
                                onPressed: () {
                                  this._controllerVisibleVN.value = false;
                                },
                                child: SizedBox(height: 40, width: 40, child: Center(child: Icon(Icons.square_outlined, color: Colors.white)))),
                            Gap(10)
                          ]);
                        }),
                        Row(children: [
                          UCOptionMenuButton("下载", icon: Icons.download_for_offline_outlined, color: Colors.white, onPressed: () async {
                            await this.onDownloadClick(context);
                          }),
                          this.qualityVN.build((value) {
                            return UCOptionMenuButton(VideoQualityCode.codeLabel(value), icon: Icons.video_camera_back_outlined, color: Colors.white,
                                onPressed: () async {
                              await this.onQualityClick(context);
                            });
                          }),
                          // UCOptionMenuButton("共有", icon: Icons.ios_share, color: Colors.white, onPressed: () async {
                          //   await this.onShareClick(context);
                          // })
                        ])
                      ])))
            ])
          ]);
        }
      });

  ///前进后退15秒按钮
  Widget seekToView(IconData icon, int value) {
    return TextButton(
        style: TextButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // 选填：紧凑的点击目标尺寸
          padding: EdgeInsets.zero,
          backgroundColor: Color(0x66000000),
          // 设置背景颜色
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999999), // 设置圆角
          ),
          minimumSize: Size(0, 0), // 设置宽度和高度
        ),
        onPressed: () async {
          final progressInfo = await this.videoController.getProgress();
          final position = Duration(milliseconds: progressInfo.current + value);
          await this.videoController.seekTo(position);

          //显示操作控件重新计时
          this._controllerVisibleTimes = 0;
        },
        child: Stack(
          children: [
            Icon(
              icon,
              size: 50,
            ),
            SizedBox(
                width: 50,
                height: 50,
                child: Center(
                    child: Text(
                  "15",
                  style: TextStyle(fontSize: 12),
                )))
          ],
        ));
  }

  ///播放状态图标
  Widget get playIconView => this._playStateVN.build((value) {
        if (value == VideoPlayerState.PAUSING) {
          return Icon(Icons.play_arrow, size: 50);
        } else {
          return Icon(Icons.pause, size: 50);
        }
      });

  ///播放按钮
  Widget get btnPlayView => TextButton(
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // 选填：紧凑的点击目标尺寸
        padding: EdgeInsets.zero,
        backgroundColor: Color(0x55000000),
        // 设置背景颜色
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999999), // 设置圆角
        ),
        minimumSize: Size(0, 0), // 设置宽度和高度
      ),
      onPressed: this.onPlayClick,
      child: SizedBox(height: 80, width: 80, child: this.playIconView));

  ///开始进度条计时器
  void _startTimer() {
    this._controllerVisibleTimes = 0;
    this._stopTimer();
    this._progressTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      this._controllerVisibleTimes++;
      if (this._controllerVisibleTimes > 5) {
        this._controllerVisibleVN.value = false;
      }
      await this.updateProgress();
      if (this._playStateVN.value == VideoPlayerState.PAUSING) {
        //如果播放器为暂停状态
        this._startTimer();
      }
    });
  }

  ///停止进度条计时器
  void _stopTimer() {
    this._progressTimer?.cancel();
  }

  ///更新播放进度
  Future<void> updateProgress() async {
    this._progressVN.value = await this.videoController.getProgress();
  }

  ///播放按钮点击事件
  Future<void> onPlayClick() async {
    if (this._playStateVN.value == VideoPlayerState.PAUSING) {
      await this.videoController.play();
      this._startTimer();
      this._playStateVN.value = VideoPlayerState.PLAYING;
    } else {
      await this.videoController.pause();
      this._stopTimer();
      this._playStateVN.value = VideoPlayerState.PAUSING;
    }
  }

  ///得到视频最佳播放质量
  int get _bestQuality{

    //当前设置的视频质量
    var videoQuality = SettingShared.videoQuality;
    var quality = VideoQualityCode.NORMAL;
    if (videoQuality != VideoQualityCode.NORMAL) {
      for (var key in this.qualityKeys!) {
        if (videoQuality >= key) {
          //当前设置的清晰度在该视频的分辨率之内
          quality = key;
          break;
        }
      }
    }
    return quality;
  }

  ///得到视频预览URL
  String get _previewUrl{

    //当前设置的视频质量
    var quality = this._bestQuality;
    var url = this.currentDfs.preview;
    if (quality != VideoQualityCode.NORMAL) {
      //设置视频质量
      if (url.contains("?")) {
        url = "$url&extra=$quality";
      } else {
        url = "$url?extra=$quality";
      }
    }
    return url;
  }

  ///画质点击事件
  Future<void> onQualityClick(BuildContext context) async {
    final qualityKeys = this.qualityKeys;
    if (qualityKeys == null) {
      return;
    }
    qualityKeys.insert(0, VideoQualityCode.NORMAL);

    //画质选择列表
    final List<Widget> actions = qualityKeys
        .map((it) => GestureDetector(
              onTap: () async {
                if (SettingShared.videoQuality == it) {
                  return;
                }
                SettingShared.videoQuality = it;
                Navigator.pop(context);
                Navigator.pop(context);

                final progress = await this.videoController.getProgress();
                context.toPage(VideoPlayerPage(dfsFileList: this.widget.dfsFileList, currentIndex: this.currentIndex, seekTo: progress.current));
              },
              child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: Row(
                    children: [
                      Spacer(),
                      it == this.qualityVN.value
                          ? Icon(Icons.check, size: Const.TEXT)
                          : SizedBox(
                              width: Const.TEXT,
                            ),
                      context.textBody(VideoQualityCode.codeLabel(it)),
                      Spacer()
                    ],
                  )),
            ))
        .toList();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: actions,
        );
      },
    );
    return;
  }

  ///下载
  Future<void> onDownloadClick(BuildContext context) async {
    final dfsFile = this.currentDfs;
    final int? saveToImageGallery;
    if (Platform.isIOS || Platform.isAndroid) {
      saveToImageGallery = await showModalActionSheet(context: context, cancelLabel: "取消", style: AdaptiveStyle.macOS, actions: [
        SheetAction(label: "添加到下载列表", key: 0, textStyle: TextStyle(color: context.color.onSurface)),
        SheetAction(label: "保存到手机相册", key: 1, textStyle: TextStyle(color: context.color.onSurface))
      ]);
      if (saveToImageGallery == null) {
        return;
      }
    } else {
      saveToImageGallery = 0;
    }

    //得到文件名
    String name = dfsFile.name;

    //得到视频最佳播放质量
    var quality = this._bestQuality;
    if(quality != VideoQualityCode.NORMAL){
      name = name.substring(0,name.lastIndexOf("."));
      name = "${name}_${VideoQualityCode.codeLabel(quality)}.mp4";
    }

    //添加到下载列表
    final dto = DownloadDto(
        name: name,
        path: "${SettingShared.downloadPath}/$name",
        url: this._previewUrl,
        thumb: dfsFile.thumb,
        saveToImageGallery: saveToImageGallery);
    DownloadDao.insert([dto]);
    DownloadTask.start();
    context.toast("已添加到下载列表");
  }

  ///分享按钮点击事件
  Future<void> onShareClick(BuildContext context) async {
    // final dfsFile = this.state.currentDfs;
    // final cacheFile = AppCacheManager.getCacheFile(dfsFile.preview);
    // if (!cacheFile.existsSync()) {
    //   context.toast("请等待图片加载完成");
    //   return;
    // }
    //
    // //保存缓存文件名
    // final cachePath = cacheFile.path;
    //
    // //临时分享的文件名
    // final sharePath = cacheFile.path.fileParent + "/" + dfsFile.name;
    // try {
    //   //临时重命名文件,分享到的APP能正确处理文件
    //   cacheFile.renameSync(sharePath);
    //   final shareFiles = [XFile(sharePath)];
    //
    //   await Share.shareXFiles(shareFiles);
    // } finally {
    //   //还原回原来的文件名
    //   File(sharePath).renameSync(cachePath);
    // }
  }

  @override
  void dispose() {
    super.dispose();
    this.http?.cancel();
  }
}
