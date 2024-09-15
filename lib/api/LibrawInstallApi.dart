import 'API.dart';
import '../util/http/NotNullApiHttp.dart';
import '../util/http/VoidApiHttp.dart';
import 'model/LibrawInstallProgressModel.dart';
class LibrawInstallApi{

///null
static VoidApiHttp install(){
 return VoidApiHttp(Api.INSTALL_LIBRAW_INSTALL);
}

///null
static NotNullApiHttp<LibrawInstallProgressModel> state(){
 return NotNullApiHttp<LibrawInstallProgressModel>(Api.INSTALL_LIBRAW_STATE,LibrawInstallProgressModel.fromJson);
}

}