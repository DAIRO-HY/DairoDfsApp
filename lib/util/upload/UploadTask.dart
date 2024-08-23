import 'dart:collection';
import 'package:dairo_dfs_app/util/upload/UploadBridge.dart';

import '../../db/dao/UploadDao.dart';
import '../shared_preferences/SettingShared.dart';

///文件上传任务
class UploadTask {

  ///当前正在上传的列表
  static final uploadingId2Bridge = HashMap<int, UploadBridge>();

  ///同时下载数
  static var syncCount = SettingShared.uploadSyncCount;

  ///开始上传
  static start() {
    while (true) {
      if (UploadTask.uploadingId2Bridge.length >= UploadTask.syncCount) {
        //同时上传数量达到了上线
        break;
      }

      ///正在上传的id
      final uploadingIds = UploadTask.uploadingId2Bridge.keys.toList().join(",");

      //获取一条需要下载的数据
      final dto = UploadDao.selectOneByNotUpload(uploadingIds);
      if (dto == null) {
        break;
      }
      final bridge = UploadBridge(dto);
      UploadTask.uploadingId2Bridge[dto.id] = bridge;
    }
    for (var it in UploadTask.uploadingId2Bridge.values) {
      it.upload();
    }
  }

  ///移除一个正在下载任务
  static void removeUploading(UploadBridge bridge) {
    UploadTask.uploadingId2Bridge.remove(bridge.dto.id);
  }
}
