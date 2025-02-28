import 'API.dart';
import '../util/http/VoidApiHttp.dart';

class CreateAdminApi {

  //管理员账号初始化
  static VoidApiHttp init(){
    return VoidApiHttp(Api.APP_INSTALL_CREATE_ADMIN);
  }

  //账号初始化API
  static VoidApiHttp addAdmin({required String name,required String pwd}){
    return VoidApiHttp(Api.APP_INSTALL_CREATE_ADMIN_ADD_ADMIN).add("name",name).add("pwd",pwd);
  }
}