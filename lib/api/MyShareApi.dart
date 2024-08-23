import 'API.dart';
import '../util/http/NotNullApiHttp.dart';
import '../util/http/VoidApiHttp.dart';
import 'model/MyShareDetailModel.dart';
import 'model/MyShareModel.dart';
class MyShareApi{

///null
static VoidApiHttp delete(){
 return VoidApiHttp(Api.MY_SHARE_DELETE);
}

///null
static NotNullApiHttp<MyShareDetailModel> getDetail(){
 return NotNullApiHttp<MyShareDetailModel>(Api.MY_SHARE_GET_DETAIL,MyShareDetailModel.fromJson);
}

///null
static NotNullApiHttp<List<MyShareModel>> getList(){
 return NotNullApiHttp<List<MyShareModel>>(Api.MY_SHARE_GET_LIST,MyShareModel.fromJsonList);
}

}