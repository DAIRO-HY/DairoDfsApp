import 'API.dart';
import '../util/http/VoidApiHttp.dart';
import 'model/UserEditInoutModel.dart';
import '../util/http/ReturnApiHttp.dart';

class UserEditApi {
  //用户编辑
  //@Group:/app/user_edit
  //@Html:.html
  static VoidApiHttp editHtml(){
    return VoidApiHttp(Api.APP_USER_EDIT_HTML);
  }
  //@Post:/init
  static ReturnApiHttp<UserEditInoutModel> editInit({required int id}){
    return ReturnApiHttp<UserEditInoutModel>(Api.APP_USER_EDIT_INIT, UserEditInoutModel.fromJson).add("id",id);
  }
  //@Post:/edit
  static VoidApiHttp edit({required int id,required String name,required String email,required int state,required String date,required String pwd}){
    return VoidApiHttp(Api.APP_USER_EDIT_EDIT).add("id",id).add("name",name).add("email",email).add("state",state).add("date",date).add("pwd",pwd);
  }
}