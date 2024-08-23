import 'API.dart';
import '../util/http/VoidApiHttp.dart';
import '../util/http/NotNullApiHttp.dart';
import 'model/ShareModel.dart';
class ShareApi{

///null
/// [id] null
static NotNullApiHttp<List<ShareModel>> getList({required String id}){
 return NotNullApiHttp<List<ShareModel>>(Api.SHARE_GET_LIST,ShareModel.fromJsonList).add("id",id);
}

///null
/// [id] null
/// [folder] null
/// [target] null
static VoidApiHttp saveTo({required String id, required String folder, required String target}){
 return VoidApiHttp(Api.SHARE_SAVE_TO).add("id",id).add("folder",folder).add("target",target);
}

///null
static VoidApiHttp validPwd(){
 return VoidApiHttp(Api.SHARE_VALID_PWD);
}

}