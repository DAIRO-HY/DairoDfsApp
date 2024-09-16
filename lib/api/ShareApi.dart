import 'API.dart';
import '../util/http/VoidApiHttp.dart';
import '../util/http/NotNullApiHttp.dart';
import 'model/ShareModel.dart';
class ShareApi{

///null
static NotNullApiHttp<List<ShareModel>> getList(){
 return NotNullApiHttp<List<ShareModel>>(Api.SHARE_{ID}_GET_LIST,ShareModel.fromJsonList);
}

///null
/// [folder] null
/// [names] null
/// [target] null
static VoidApiHttp saveTo({required String folder, required Array<String> names, required String target}){
 return VoidApiHttp(Api.SHARE_{ID}_SAVE_TO).add("folder",folder).add("names",names).add("target",target);
}

///null
static VoidApiHttp validPwd(){
 return VoidApiHttp(Api.SHARE_{ID}_VALID_PWD);
}

}