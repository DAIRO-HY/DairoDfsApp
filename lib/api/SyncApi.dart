import 'API.dart';
import '../util/http/VoidApiHttp.dart';
import '../util/http/NotNullApiHttp.dart';
import 'model/SyncModel.dart';
class SyncApi{

///null
static NotNullApiHttp<List<SyncModel>> infoList(){
 return NotNullApiHttp<List<SyncModel>>(Api.SYNC_INFO_LIST,SyncModel.fromJsonList);
}

///null
static VoidApiHttp sync(){
 return VoidApiHttp(Api.SYNC_SYNC);
}

///null
static VoidApiHttp syncAll(){
 return VoidApiHttp(Api.SYNC_SYNC_ALL);
}

}