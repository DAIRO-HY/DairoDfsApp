import 'API.dart';
import '../util/http/VoidApiHttp.dart';
import 'model/MineModel.dart';
import '../util/http/ReturnApiHttp.dart';

class MineApi {
  // 系统设置
  //@Group:/app/mine
  // 页面初始化
  // @Html:.html
  static VoidApiHttp html(){
    return VoidApiHttp(Api.APP_MINE_HTML);
  }
  // 页面初始化
  // @Post:/init
  static ReturnApiHttp<MineModel> init(){
    return ReturnApiHttp<MineModel>(Api.APP_MINE_INIT, MineModel.fromJson);
  }
  //@Post:/make_api_token
  static VoidApiHttp makeApiToken({required int flag}){
    return VoidApiHttp(Api.APP_MINE_MAKE_API_TOKEN).add("flag",flag);
  }
  //@Post:/make_url_path
  static VoidApiHttp makeUrlPath({required int flag}){
    return VoidApiHttp(Api.APP_MINE_MAKE_URL_PATH).add("flag",flag);
  }
  //@Post:/make_encryption
  static VoidApiHttp makeEncryption({required int flag}){
    return VoidApiHttp(Api.APP_MINE_MAKE_ENCRYPTION).add("flag",flag);
  }
}