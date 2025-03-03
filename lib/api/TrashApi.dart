import 'API.dart';
import '../util/http/ReturnApiHttp.dart';
import '../util/http/VoidApiHttp.dart';
import 'model/TrashModel.dart';

class TrashApi {

  static VoidApiHttp html(){
    return VoidApiHttp(Api.APP_TRASH_HTML);
  }

  //获取回收站文件列表
  static ReturnApiHttp<List<TrashModel>> getList(){
    return ReturnApiHttp<List<TrashModel>>(Api.APP_TRASH_GET_LIST, TrashModel.fromJsonList);
  }

  //彻底删除文件
  //ids 选中的文件ID列表
  static VoidApiHttp logicDelete({required List<int> ids}){
    return VoidApiHttp(Api.APP_TRASH_LOGIC_DELETE).add("ids",ids);
  }

  //从垃圾箱还原文件
  //ids 选中的文件ID列表
  static VoidApiHttp trashRecover({required List<int> ids}){
    return VoidApiHttp(Api.APP_TRASH_TRASH_RECOVER).add("ids",ids);
  }

  //立即回收储存空间
  static VoidApiHttp recycleStorage(){
    return VoidApiHttp(Api.APP_TRASH_RECYCLE_STORAGE);
  }
}