import 'API.dart';
import '../util/http/NotNullApiHttp.dart';
import 'model/UserInfoModel.dart';
class UserApi{

///获取用户信息
static NotNullApiHttp<UserInfoModel> getUserInfo(){
 return NotNullApiHttp<UserInfoModel>(Api.USER_GET_USER_INFO,UserInfoModel.fromJson);
}

}