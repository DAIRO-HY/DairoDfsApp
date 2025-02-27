import 'API.dart';
import '../util/http/VoidApiHttp.dart';

class FfprobeInstallApi {
  // @Get:
  // @Html:app/install/ffprobe.html
  static VoidApiHttp html(){
    return VoidApiHttp(Api.APP_INSTALL_FFPROBE);
  }
  // 资源回收
  // @Post:/recycle
  static VoidApiHttp recycle(){
    return VoidApiHttp(Api.APP_INSTALL_FFPROBE_RECYCLE);
  }
  //@Post:/install
  static VoidApiHttp install(){
    return VoidApiHttp(Api.APP_INSTALL_FFPROBE_INSTALL);
  }
  // 当前安装进度
  // @Request:/progress
  static VoidApiHttp progress(){
    return VoidApiHttp(Api.APP_INSTALL_FFPROBE_PROGRESS);
  }
}