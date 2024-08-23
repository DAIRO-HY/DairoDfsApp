import 'API.dart';
import '../util/http/NotNullApiHttp.dart';
import 'model/UserListModel.dart';
class UserListApi{

///null
static NotNullApiHttp<List<UserListModel>> init(){
 return NotNullApiHttp<List<UserListModel>>(Api.USER_LIST,UserListModel.fromJsonList);
}

}