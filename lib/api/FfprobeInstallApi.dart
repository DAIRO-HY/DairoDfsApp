import 'API.dart';
import '../util/http/VoidApiHttp.dart';

class FfprobeInstallApi {

  static VoidApiHttp html(){
    return VoidApiHttp(Api.APP_INSTALL_FFPROBE);
  }

  //资源回收
  static VoidApiHttp recycle(){
    return VoidApiHttp(Api.APP_INSTALL_FFPROBE_RECYCLE);
  }

  static VoidApiHttp install(){
    return VoidApiHttp(Api.APP_INSTALL_FFPROBE_INSTALL);
  }

  //当前安装进度
  static VoidApiHttp progress(){
    return VoidApiHttp(Api.APP_INSTALL_FFPROBE_PROGRESS);
  }
}