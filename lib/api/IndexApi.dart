import 'API.dart';
import '../util/http/VoidApiHttp.dart';

class IndexApi {
  // 页面初始化
  // @Html:index.html
  static VoidApiHttp index(){
    return VoidApiHttp(Api.INDEX_HTML);
  }
}