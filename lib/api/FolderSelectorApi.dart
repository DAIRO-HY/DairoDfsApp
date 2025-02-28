import 'API.dart';
import 'model/FolderModel.dart';
import '../util/http/ReturnApiHttp.dart';

class FolderSelectorApi {

  //获取文件夹结构
  static ReturnApiHttp<List<FolderModel>> getList({required String folder}){
    return ReturnApiHttp<List<FolderModel>>(Api.APP_FOLDER_SELECTOR_GET_LIST, FolderModel.fromJsonList).add("folder",folder);
  }
}