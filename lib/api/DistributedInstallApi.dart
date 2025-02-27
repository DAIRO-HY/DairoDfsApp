import 'API.dart';
import '../util/http/VoidApiHttp.dart';

class DistributedInstallApi {
  //@Group:/app/install/distributed
  // @Get:
  // @Html:app/install/distributed.html
  static VoidApiHttp html(){
    return VoidApiHttp(Api.APP_INSTALL_DISTRIBUTED);
  }
  //@Post:/set
  static VoidApiHttp set({required List<String> syncUrl}){
    return VoidApiHttp(Api.APP_INSTALL_DISTRIBUTED_SET).add("syncUrl",syncUrl);
  }
}