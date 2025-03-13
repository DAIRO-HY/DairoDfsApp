import 'API.dart';
import 'model/MyShareModel.dart';
import '../util/http/ReturnApiHttp.dart';
import 'model/MyShareDetailModel.dart';
import '../util/http/VoidApiHttp.dart';

class MyShareApi {

  static VoidApiHttp html(){
    return VoidApiHttp(Api.APP_MY_SHARE_HTML);
  }

  //获取所有的分享
  static ReturnApiHttp<List<MyShareModel>> getList(){
    return ReturnApiHttp<List<MyShareModel>>(Api.APP_MY_SHARE_GET_LIST, MyShareModel.fromJsonList);
  }

  //获取分享详细
  //id 分享id
  static ReturnApiHttp<MyShareDetailModel> getDetail({required int id}){
    return ReturnApiHttp<MyShareDetailModel>(Api.APP_MY_SHARE_GET_DETAIL, MyShareDetailModel.fromJson).add("id",id);
  }

  //取消所选分享
  //ids 分享id列表
  static VoidApiHttp delete({required List<int> ids}){
    return VoidApiHttp(Api.APP_MY_SHARE_DELETE).add("ids",ids);
  }
}