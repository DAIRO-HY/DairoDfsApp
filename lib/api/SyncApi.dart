import 'API.dart';
import '../util/http/VoidApiHttp.dart';
import 'model/SyncServerModel.dart';
import '../util/http/ReturnApiHttp.dart';

class SyncApi {
  // 数据同步状态
  //@Group: /app/sync
  // @Html:.html
  static VoidApiHttp html(){
    return VoidApiHttp(Api.APP_SYNC_HTML);
  }
  // 页面数据初始化
  // @Post:/info_list
  static ReturnApiHttp<List<SyncServerModel>> infoList(){
    return ReturnApiHttp<List<SyncServerModel>>(Api.APP_SYNC_INFO_LIST, SyncServerModel.fromJsonList);
  }
  // 日志同步
  // @Post:/by_log
  static VoidApiHttp bySync(){
    return VoidApiHttp(Api.APP_SYNC_BY_LOG);
  }
  // 全量同步
  // @Post:/by_table
  static VoidApiHttp byTable(){
    return VoidApiHttp(Api.APP_SYNC_BY_TABLE);
  }
  // 当前同步状态
  // @Request:/info
  static VoidApiHttp info(){
    return VoidApiHttp(Api.APP_SYNC_INFO);
  }
}