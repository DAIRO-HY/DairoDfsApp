import 'API.dart';
import '../util/http/VoidApiHttp.dart';

class DistributedInstallApi {

  static VoidApiHttp html(){
    return VoidApiHttp(Api.APP_INSTALL_DISTRIBUTED);
  }

  static VoidApiHttp set({required List<String> syncUrl}){
    return VoidApiHttp(Api.APP_INSTALL_DISTRIBUTED_SET).add("syncUrl",syncUrl);
  }
}