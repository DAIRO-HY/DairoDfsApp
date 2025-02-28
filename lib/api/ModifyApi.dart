import 'API.dart';
import '../util/http/VoidApiHttp.dart';

class ModifyApi {

  //密码修改
  static VoidApiHttp html(){
    return VoidApiHttp(Api.APP_MODIFY_PWD_HTML);
  }

  //修改密码
  static VoidApiHttp modify({required String oldPwd,required String pwd}){
    return VoidApiHttp(Api.APP_MODIFY_PWD_MODIFY).add("oldPwd",oldPwd).add("pwd",pwd);
  }
}