import 'API.dart';
import '../util/http/VoidApiHttp.dart';
import 'model/LoginAppOutModel.dart';
import '../util/http/ReturnApiHttp.dart';

class LoginApi {
  //登录页面
  //@Group:/app/login
  //@Get:
  //@Html:/app/login.html
  static VoidApiHttp init(){
    return VoidApiHttp(Api.APP_LOGIN);
  }
  //@Post:/do_login
  static ReturnApiHttp<LoginAppOutModel> doLogin({required String name,required String pwd,required String deviceId}){
    return ReturnApiHttp<LoginAppOutModel>(Api.APP_LOGIN_DO_LOGIN, LoginAppOutModel.fromJson).add("name",name).add("pwd",pwd).add("deviceId",deviceId);
  }
  //@Post:/logout
  static VoidApiHttp logout(){
    return VoidApiHttp(Api.APP_LOGIN_LOGOUT);
  }
}