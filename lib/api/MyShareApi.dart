import 'API.dart';
import '../util/http/VoidApiHttp.dart';
import 'model/MyShareModel.dart';
import '../util/http/ReturnApiHttp.dart';
import 'model/MyShareDetailModel.dart';

class MyShareApi {
  //@Group:/app/my_share
  //@Html:.html
  static VoidApiHttp html(){
    return VoidApiHttp(Api.APP_MY_SHARE_HTML);
  }
  // 获取所有的分享
  // @Post:/get_list
  static ReturnApiHttp<List<MyShareModel>> getList(){
    return ReturnApiHttp<List<MyShareModel>>(Api.APP_MY_SHARE_GET_LIST, MyShareModel.fromJsonList);
  }
  // 获取分享详细
  // id 分享id
  // @Post:/get_detail
  static ReturnApiHttp<MyShareDetailModel> getDetail({required int id}){
    return ReturnApiHttp<MyShareDetailModel>(Api.APP_MY_SHARE_GET_DETAIL, MyShareDetailModel.fromJson).add("id",id);
  }
  // 取消所选分享
  // @Post:/delete
  // ids 分享id列表
  static VoidApiHttp delete({required List<int> ids}){
    return VoidApiHttp(Api.APP_MY_SHARE_DELETE).add("ids",ids);
  }
}