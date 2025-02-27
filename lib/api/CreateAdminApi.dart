import 'API.dart';
import '../util/http/VoidApiHttp.dart';

class CreateAdminApi {
  //@Group: /app/install/create_admin
  // 管理员账号初始化
  // @Get:
  // @Html:app/install/create_admin.html
  static VoidApiHttp init(){
    return VoidApiHttp(Api.APP_INSTALL_CREATE_ADMIN);
  }
  // 账号初始化API
  // @Post:/add_admin
  static VoidApiHttp addAdmin({required String name,required String pwd}){
    return VoidApiHttp(Api.APP_INSTALL_CREATE_ADMIN_ADD_ADMIN).add("name",name).add("pwd",pwd);
  }
}