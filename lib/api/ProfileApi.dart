import 'API.dart';
import '../util/http/VoidApiHttp.dart';
import '../util/http/NotNullApiHttp.dart';
import 'model/ProfileModel.dart';
class ProfileApi{

///null
static NotNullApiHttp<ProfileModel> init(){
 return NotNullApiHttp<ProfileModel>(Api.PROFILE,ProfileModel.fromJson);
}

///null
/// [uploadMaxSize] null
/// [folders] null
/// [syncDomains] null
static VoidApiHttp update({required String uploadMaxSize, required String folders, String? syncDomains}){
 return VoidApiHttp(Api.PROFILE_UPDATE).add("uploadMaxSize",uploadMaxSize).add("folders",folders).add("syncDomains",syncDomains);
}

}