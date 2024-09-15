import 'API.dart';
import '../util/http/NotNullApiHttp.dart';
import '../util/http/VoidApiHttp.dart';
import 'model/FfmpegInstallProgressModel.dart';
class FfmpegInstallApi{

///null
static VoidApiHttp install(){
 return VoidApiHttp(Api.INSTALL_FFMPEG_INSTALL);
}

///null
static NotNullApiHttp<FfmpegInstallProgressModel> progress(){
 return NotNullApiHttp<FfmpegInstallProgressModel>(Api.INSTALL_FFMPEG_PROGRESS,FfmpegInstallProgressModel.fromJson);
}

}