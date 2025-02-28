import 'API.dart';
import '../util/http/VoidApiHttp.dart';

class SetStorageInstallApi {

  static VoidApiHttp html(){
    return VoidApiHttp(Api.APP_INSTALL_SET_STORAGE);
  }

  static VoidApiHttp set({required List<String> path}){
    return VoidApiHttp(Api.APP_INSTALL_SET_STORAGE_SET).add("path",path);
  }
}