import 'API.dart';
import '../util/http/VoidApiHttp.dart';

class FfmpegInstallApi {
  // @Get:
  // @Html:app/install/ffmpeg.html
  static VoidApiHttp html(){
    return VoidApiHttp(Api.APP_INSTALL_FFMPEG);
  }
  // 资源回收
  // @Post:/recycle
  static VoidApiHttp recycle(){
    return VoidApiHttp(Api.APP_INSTALL_FFMPEG_RECYCLE);
  }
  //@Post:/install
  static VoidApiHttp install(){
    return VoidApiHttp(Api.APP_INSTALL_FFMPEG_INSTALL);
  }
  // 当前安装进度
  // @Request:/progress
  static VoidApiHttp progress(){
    return VoidApiHttp(Api.APP_INSTALL_FFMPEG_PROGRESS);
  }
}