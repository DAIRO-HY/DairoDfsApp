import 'API.dart';
import '../util/http/VoidApiHttp.dart';
import 'model/MineModel.dart';
import '../util/http/ReturnApiHttp.dart';

class MineApi {

  //系统设置
  //页面初始化
  static VoidApiHttp html(){
    return VoidApiHttp(Api.APP_MINE_HTML);
  }

  //页面初始化
  static ReturnApiHttp<MineModel> init(){
    return ReturnApiHttp<MineModel>(Api.APP_MINE_INIT, MineModel.fromJson);
  }

  static VoidApiHttp makeApiToken({required int flag}){
    return VoidApiHttp(Api.APP_MINE_MAKE_API_TOKEN).add("flag",flag);
  }

  static VoidApiHttp makeUrlPath({required int flag}){
    return VoidApiHttp(Api.APP_MINE_MAKE_URL_PATH).add("flag",flag);
  }

  static VoidApiHttp makeEncryption({required int flag}){
    return VoidApiHttp(Api.APP_MINE_MAKE_ENCRYPTION).add("flag",flag);
  }
}