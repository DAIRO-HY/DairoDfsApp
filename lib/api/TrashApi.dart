import 'API.dart';
import '../util/http/VoidApiHttp.dart';
import '../util/http/NotNullApiHttp.dart';
import 'model/TrashModel.dart';
class TrashApi{

///获取回收站文件列表
static NotNullApiHttp<List<TrashModel>> getList(){
 return NotNullApiHttp<List<TrashModel>>(Api.TRASH_GET_LIST,TrashModel.fromJsonList);
}

///彻底删除文件
/// [ids] 选中的文件ID列表
static VoidApiHttp logicDelete({required List<int> ids}){
 return VoidApiHttp(Api.TRASH_LOGIC_DELETE).add("ids",ids);
}

///从垃圾箱还原文件
/// [ids] 选中的文件ID列表
static VoidApiHttp trashRecover({required List<int> ids}){
 return VoidApiHttp(Api.TRASH_TRASH_RECOVER).add("ids",ids);
}

}