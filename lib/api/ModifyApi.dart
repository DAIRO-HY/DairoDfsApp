import 'API.dart';
import '../util/http/VoidApiHttp.dart';
class ModifyApi{

///修改密码
/// [oldPwd] 旧密码
/// [pwd] 新密码
static VoidApiHttp modify({required String oldPwd, required String pwd}){
 return VoidApiHttp(Api.MODIFY_PWD_MODIFY).add("oldPwd",oldPwd).add("pwd",pwd);
}

}