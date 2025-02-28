import 'API.dart';
import '../util/http/VoidApiHttp.dart';

class AboutApi {

  static VoidApiHttp html(){
    return VoidApiHttp(Api.APP_ABOUT_HTML);
  }
}