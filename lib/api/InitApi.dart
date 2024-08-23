import 'API.dart';
import '../util/http/VoidApiHttp.dart';
class InitApi{

///null
/// [name] null
/// [pwd] null
static VoidApiHttp addAdmin({required String name, required String pwd}){
 return VoidApiHttp(Api.INIT_ADD_ADMIN).add("name",name).add("pwd",pwd);
}

}