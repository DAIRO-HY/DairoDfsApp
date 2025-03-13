import 'API.dart';
import 'model/SyncServerModel.dart';
import '../util/http/ReturnApiHttp.dart';
import '../util/http/VoidApiHttp.dart';

class SyncApi {

  //数据同步状态
  static VoidApiHttp html(){
    return VoidApiHttp(Api.APP_SYNC_HTML);
  }

  //页面数据初始化
  static ReturnApiHttp<List<SyncServerModel>> infoList(){
    return ReturnApiHttp<List<SyncServerModel>>(Api.APP_SYNC_INFO_LIST, SyncServerModel.fromJsonList);
  }

  //日志同步
  static VoidApiHttp bySync(){
    return VoidApiHttp(Api.APP_SYNC_BY_LOG);
  }

  //全量同步
  static VoidApiHttp byTable(){
    return VoidApiHttp(Api.APP_SYNC_BY_TABLE);
  }

  //当前同步状态
  static VoidApiHttp info(){
    return VoidApiHttp(Api.APP_SYNC_INFO);
  }
}