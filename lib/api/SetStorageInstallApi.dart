import 'API.dart';
import '../util/http/VoidApiHttp.dart';
class SetStorageInstallApi{

///null
static VoidApiHttp set(){
 return VoidApiHttp(Api.INSTALL_SET_STORAGE_SET);
}

}