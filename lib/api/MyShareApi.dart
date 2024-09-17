import 'API.dart';
import '../util/http/NotNullApiHttp.dart';
import '../util/http/VoidApiHttp.dart';
import 'model/MyShareDetailModel.dart';
import 'model/MyShareModel.dart';
class MyShareApi{

///取消所选分享
/// [ids] 分享id列表
static VoidApiHttp delete({required List<int> ids}){
 return VoidApiHttp(Api.MY_SHARE_DELETE).add("ids",ids);
}

///获取分享详细
/// [id] 分享id
static NotNullApiHttp<MyShareDetailModel> getDetail({required int id}){
 return NotNullApiHttp<MyShareDetailModel>(Api.MY_SHARE_GET_DETAIL,MyShareDetailModel.fromJson).add("id",id);
}

///获取所有的分享
static NotNullApiHttp<List<MyShareModel>> getList(){
 return NotNullApiHttp<List<MyShareModel>>(Api.MY_SHARE_GET_LIST,MyShareModel.fromJsonList);
}

}