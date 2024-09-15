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
static VoidApiHttp makeToken(){
 return VoidApiHttp(Api.PROFILE_MAKE_TOKEN);
}

///null
/// [openSqlLog] null
/// [hasReadOnly] null
/// [uploadMaxSize] null
/// [folders] null
/// [syncDomains] null
/// [token] null
static VoidApiHttp update({bool? openSqlLog, bool? hasReadOnly, required String uploadMaxSize, required String folders, String? syncDomains, String? token}){
 return VoidApiHttp(Api.PROFILE_UPDATE).add("openSqlLog",openSqlLog).add("hasReadOnly",hasReadOnly).add("uploadMaxSize",uploadMaxSize).add("folders",folders).add("syncDomains",syncDomains).add("token",token);
}

}