import 'API.dart';
import '../util/http/VoidApiHttp.dart';
import '../util/http/NotNullApiHttp.dart';
import 'model/SelfSetModel.dart';
class SelfSetApi{

///null
static NotNullApiHttp<SelfSetModel> init(){
 return NotNullApiHttp<SelfSetModel>(Api.SELF_SET,SelfSetModel.fromJson);
}

///null
static VoidApiHttp makeApiToken(){
 return VoidApiHttp(Api.SELF_SET_MAKE_API_TOKEN);
}

///null
static VoidApiHttp makeEncryption(){
 return VoidApiHttp(Api.SELF_SET_MAKE_ENCRYPTION);
}

///null
static VoidApiHttp makeUrlPath(){
 return VoidApiHttp(Api.SELF_SET_MAKE_URL_PATH);
}

}