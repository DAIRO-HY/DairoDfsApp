import 'API.dart';
import 'model/LoginAppOutModel.dart';
import '../util/http/ReturnApiHttp.dart';
import '../util/http/VoidApiHttp.dart';

class LoginApi {

  //登录页面
  static VoidApiHttp init(){
    return VoidApiHttp(Api.APP_LOGIN);
  }

  static ReturnApiHttp<LoginAppOutModel> doLogin({required String name,required String pwd,required String deviceId}){
    return ReturnApiHttp<LoginAppOutModel>(Api.APP_LOGIN_DO_LOGIN, LoginAppOutModel.fromJson).add("name",name).add("pwd",pwd).add("deviceId",deviceId);
  }

  static VoidApiHttp logout(){
    return VoidApiHttp(Api.APP_LOGIN_LOGOUT);
  }
}