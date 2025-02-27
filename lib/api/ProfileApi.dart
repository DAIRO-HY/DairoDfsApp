import 'API.dart';
import '../util/http/VoidApiHttp.dart';
import 'model/ProfileModel.dart';
import '../util/http/ReturnApiHttp.dart';

class ProfileApi {
  //系统配置
  //@Group:/app/profile
  // 页面初始化
  // @Html:.html
  static VoidApiHttp html(){
    return VoidApiHttp(Api.APP_PROFILE_HTML);
  }
  // 页面数据初始化
  // @Post:/init
  static ReturnApiHttp<ProfileModel> init(){
    return ReturnApiHttp<ProfileModel>(Api.APP_PROFILE_INIT, ProfileModel.fromJson);
  }
  // 页面初始化
  // @Post:/update
  static VoidApiHttp update({required bool openSqlLog,required bool hasReadOnly,required int uploadMaxSize,required String folders,required String syncDomains,required String token,required int trashTimeout,required int deleteStorageTimeout}){
    return VoidApiHttp(Api.APP_PROFILE_UPDATE).add("openSqlLog",openSqlLog).add("hasReadOnly",hasReadOnly).add("uploadMaxSize",uploadMaxSize).add("folders",folders).add("syncDomains",syncDomains).add("token",token).add("trashTimeout",trashTimeout).add("deleteStorageTimeout",deleteStorageTimeout);
  }
  // 切换token
  // @Post:/make_token
  static VoidApiHttp makeToken(){
    return VoidApiHttp(Api.APP_PROFILE_MAKE_TOKEN);
  }
}