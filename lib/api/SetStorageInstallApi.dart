import 'API.dart';
import '../util/http/VoidApiHttp.dart';

class SetStorageInstallApi {
  //@Group:/app/install/set_storage
  // @Get:
  // @Html:app/install/set_storage.html
  static VoidApiHttp html(){
    return VoidApiHttp(Api.APP_INSTALL_SET_STORAGE);
  }
  //@Post:/set
  static VoidApiHttp set({required List<String> path}){
    return VoidApiHttp(Api.APP_INSTALL_SET_STORAGE_SET).add("path",path);
  }
}