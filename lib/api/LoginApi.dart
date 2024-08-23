import 'API.dart';
import '../util/http/NullApiHttp.dart';
import '../util/http/VoidApiHttp.dart';
import '../util/http/NotNullApiHttp.dart';
import 'model/UserInfoModel.dart';
class LoginApi{

///用户登录
/// [name] 用户名
/// [pwd] 登录密码(MD5)
/// [deviceId] 设备唯一标识
static NotNullApiHttp<String> doLogin({required String name, required String pwd, required String deviceId}){
 return NotNullApiHttp<String>(Api.LOGIN_DO_LOGIN).add("name",name).add("pwd",pwd).add("deviceId",deviceId);
}

///null
static NotNullApiHttp<String> forget(){
 return NotNullApiHttp<String>(Api.LOGIN_FORGET);
}

///null
static VoidApiHttp logout(){
 return VoidApiHttp(Api.LOGIN_LOGOUT);
}

///null
static NotNullApiHttp<int> returnInt(){
 return NotNullApiHttp<int>(Api.LOGIN_RETURNINT);
}

///null
static NullApiHttp<UserInfoModel?> returnNull(){
 return NullApiHttp<UserInfoModel?>(Api.LOGIN_RETURNNULL,UserInfoModel.fromJson);
}

///null
static VoidApiHttp returnVoid(){
 return VoidApiHttp(Api.LOGIN_RETURNVOID);
}

}