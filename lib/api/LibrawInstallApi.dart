import 'API.dart';
import '../util/http/VoidApiHttp.dart';

class LibrawInstallApi {

  static VoidApiHttp html(){
    return VoidApiHttp(Api.APP_INSTALL_LIBRAW);
  }

  //资源回收
  static VoidApiHttp recycle(){
    return VoidApiHttp(Api.APP_INSTALL_LIBRAW_RECYCLE);
  }

  static VoidApiHttp install(){
    return VoidApiHttp(Api.APP_INSTALL_LIBRAW_INSTALL);
  }

  //当前安装进度
  static VoidApiHttp progress(){
    return VoidApiHttp(Api.APP_INSTALL_LIBRAW_PROGRESS);
  }
}