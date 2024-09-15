import 'API.dart';
import '../util/http/VoidApiHttp.dart';
class CreateAdminApi{

///null
/// [name] null
/// [pwd] null
static VoidApiHttp addAdmin({required String name, required String pwd}){
 return VoidApiHttp(Api.INSTALL_CREATE_ADMIN_ADD_ADMIN).add("name",name).add("pwd",pwd);
}

}