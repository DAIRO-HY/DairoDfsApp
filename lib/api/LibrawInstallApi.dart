import 'API.dart';
import '../util/http/VoidApiHttp.dart';

class LibrawInstallApi {
  // @Get:
  // @Html:app/install/libraw.html
  static VoidApiHttp html(){
    return VoidApiHttp(Api.APP_INSTALL_LIBRAW);
  }
  // 资源回收
  // @Post:/recycle
  static VoidApiHttp recycle(){
    return VoidApiHttp(Api.APP_INSTALL_LIBRAW_RECYCLE);
  }
  //@Post:/install
  static VoidApiHttp install(){
    return VoidApiHttp(Api.APP_INSTALL_LIBRAW_INSTALL);
  }
  // 当前安装进度
  // @Request:/progress
  static VoidApiHttp progress(){
    return VoidApiHttp(Api.APP_INSTALL_LIBRAW_PROGRESS);
  }
}