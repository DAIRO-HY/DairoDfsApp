import 'API.dart';
import '../util/http/NotNullApiHttp.dart';
import '../util/http/VoidApiHttp.dart';
import 'model/FfprobeInstallProgressModel.dart';
class FfprobeInstallApi{

///null
static VoidApiHttp install(){
 return VoidApiHttp(Api.INSTALL_FFPROBE_INSTALL);
}

///null
static NotNullApiHttp<FfprobeInstallProgressModel> progress(){
 return NotNullApiHttp<FfprobeInstallProgressModel>(Api.INSTALL_FFPROBE_PROGRESS,FfprobeInstallProgressModel.fromJson);
}

}