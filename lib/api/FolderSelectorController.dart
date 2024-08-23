import 'API.dart';
import '../util/http/NotNullApiHttp.dart';
import 'model/FolderModel.dart';
class FolderSelectorController{

///null
static NotNullApiHttp<List<FolderModel>> getList(){
 return NotNullApiHttp<List<FolderModel>>(Api.FOLDER_SELECTOR_GET_LIST,FolderModel.fromJsonList);
}

}