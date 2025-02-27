import 'API.dart';
import '../util/http/VoidApiHttp.dart';
import 'model/UserListOutModel.dart';
import '../util/http/ReturnApiHttp.dart';

class UserListApi {
  //用户列表
  //@Group:/app/user_list
  //@Html:.html
  static VoidApiHttp listHtml(){
    return VoidApiHttp(Api.APP_USER_LIST_HTML);
  }
  //@Post:/init
  static ReturnApiHttp<List<UserListOutModel>> listInit(){
    return ReturnApiHttp<List<UserListOutModel>>(Api.APP_USER_LIST_INIT, UserListOutModel.fromJsonList);
  }
}