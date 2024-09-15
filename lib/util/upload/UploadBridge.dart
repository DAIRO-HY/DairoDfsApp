import 'package:dairo_dfs_app/extension/Number++.dart';
import 'package:dairo_dfs_app/util/shared_preferences/SettingShared.dart';
import '../../db/dao/UploadDao.dart';
import '../../db/dto/UploadDto.dart';
import '../even_bus/EventCode.dart';
import '../even_bus/EventUtil.dart';
import 'UploadManager.dart';
import 'UploadTask.dart';

class UploadBridge {
  ///控制保存时间间隔
  static const SAVE_DOWNLOAD_SIZE_TIMER = 10 * 1000;

  ///下载文件信息
  UploadDto dto;

  ///上传管理
  UploadManager? _uploadManager;

  ///记录最后一次保存进度时间
  int lastSaveTime = 0;

  UploadBridge(this.dto);

  ///上传进度
  double get progress {
    if (this.dto.size == 0) {
      //这是一个空文件
      return 1;
    }
    return this.dto.uploadedSize / this.dto.size;
  }

  ///开始上传
  void upload() {
    if (this._uploadManager != null) {
      //任务已经在下载中，无需重复添加
      return;
    }
    this.dto.state = 1;
    final info = UploadingInfo(
        md5: this.dto.md5, token: SettingShared.token!, size: this.dto.size, path: this.dto.path, dfsPath: "${this.dto.dfsFolder}/${this.dto.name}");
    this._uploadManager = UploadManager(
        info: info,
        onSuccess: this.onSuccess,
        onError: this.onError,
        onProgress: this.onProgress,
        onStateMsgChange: this.onStateMsgChange,
        onMd5Compute: this.onMd5Compute);
    this._uploadManager!.upload();
  }

  ///暂停下载
  void pause() {
    UploadDao.setProgress(this.dto.id, this.dto.uploadedSize);
    this._uploadManager?.pause();
  }

  ///下载完成回调函数
  void onSuccess() {
    //标记为下载完成
    UploadDao.setState(this.dto.id, 10);
    this._uploadManager = null;

    ///从正在下载的任务列表中将自己移除
    UploadTask.removeUploading(this);
    UploadTask.start();

    //通知刷新页面
    EventUtil.post(EventCode.UPLOAD_PAGE_RELOAD, this.dto.dfsFolder);
  }

  ///下载完成回调函数
  void onError(String error) {
    if (error == "PAUSE") {
      //暂停操作
      UploadDao.setState(this.dto.id, 2);
    } else {
      UploadDao.setState(this.dto.id, 3, error);
    }
    this._uploadManager = null;

    ///从正在下载的任务列表中将自己移除
    UploadTask.removeUploading(this);
    UploadTask.start();

    //通知刷新页面
    EventUtil.post(EventCode.UPLOAD_PROGRESS);
  }

  ///下载完成回调函数
  void onProgress(int size, int uploadedSize, int speed, int remainder) {
    this.dto.size = size;
    this.dto.uploadedSize = uploadedSize;
    this.dto.msg = "${speed.dataSize}/S 剩余时间：${remainder.timeFormat}";

    //控制保存频率
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - this.lastSaveTime > UploadBridge.SAVE_DOWNLOAD_SIZE_TIMER) {
      UploadDao.setProgress(this.dto.id, uploadedSize);
      this.lastSaveTime = now;
    }

    //通知刷新页面
    EventUtil.post(EventCode.UPLOAD_PROGRESS);
  }

  ///设置消息
  void onStateMsgChange(String msg) {
    this.dto.msg = msg;

    //通知刷新页面
    EventUtil.post(EventCode.UPLOAD_PROGRESS);
  }

  ///md5计算完成
  void onMd5Compute(String md5) {
    UploadDao.setMd5(this.dto.id, md5);
  }
}
