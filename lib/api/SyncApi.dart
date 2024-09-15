import 'API.dart';
import '../util/http/VoidApiHttp.dart';
import '../util/http/NotNullApiHttp.dart';
import 'model/SyncServerModel.dart';
class SyncApi{

///null
static NotNullApiHttp<List<SyncServerModel>> infoList(){
 return NotNullApiHttp<List<SyncServerModel>>(Api.SYNC_INFO_LIST,SyncServerModel.fromJsonList);
}

///null
static VoidApiHttp sync(){
 return VoidApiHttp(Api.SYNC_BY_LOG);
}

///null
static VoidApiHttp syncAll(){
 return VoidApiHttp(Api.SYNC_BY_TABLE);
}

}