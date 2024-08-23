import 'API.dart';
import '../util/http/NotNullApiHttp.dart';
import '../util/http/VoidApiHttp.dart';
import 'model/UserEditModel.dart';
class UserEditApi{

///null
/// [id] null
/// [name] null
/// [email] null
/// [state] null
/// [date] null
static VoidApiHttp edit({int? id, String? name, required String email, int? state, String? date}){
 return VoidApiHttp(Api.USER_EDIT_EDIT).add("id",id).add("name",name).add("email",email).add("state",state).add("date",date);
}

///null
static NotNullApiHttp<UserEditModel> init(){
 return NotNullApiHttp<UserEditModel>(Api.USER_EDIT,UserEditModel.fromJson);
}

}