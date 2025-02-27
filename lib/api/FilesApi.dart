import 'API.dart';
import '../util/http/VoidApiHttp.dart';
import 'model/FileModel.dart';
import '../util/http/ReturnApiHttp.dart';
import 'model/FilePropertyModel.dart';

class FilesApi {
  // 文件列表页面
  //@Group:/app/files
  // @Html:.html
  static VoidApiHttp html(){
    return VoidApiHttp(Api.APP_FILES_HTML);
  }
  // 获取文件列表
  // @Post:/get_list
  static ReturnApiHttp<List<FileModel>> getList({required String folder}){
    return ReturnApiHttp<List<FileModel>>(Api.APP_FILES_GET_LIST, FileModel.fromJsonList).add("folder",folder);
  }
  // 获取扩展文件的所有key值
  // id 文件id
  // @Post:/get_extra_keys
  static ReturnApiHttp<List<String>> getExtraKeys({required int id}){
    return ReturnApiHttp<List<String>>(Api.APP_FILES_GET_EXTRA_KEYS).add("id",id);
  }
  // 创建文件夹
  // @Post:/create_folder
  static VoidApiHttp createFolder({required String folder}){
    return VoidApiHttp(Api.APP_FILES_CREATE_FOLDER).add("folder",folder);
  }
  // 删除文件
  // @Post:/delete
  static VoidApiHttp delete({required List<String> paths}){
    return VoidApiHttp(Api.APP_FILES_DELETE).add("paths",paths);
  }
  // 重命名
  // sourcePath 源路径
  // name 新名称
  // @Post:/rename
  static VoidApiHttp rename({required String sourcePath,required String name}){
    return VoidApiHttp(Api.APP_FILES_RENAME).add("sourcePath",sourcePath).add("name",name);
  }
  // 文件复制
  // sourcePaths 源路径
  // targetFolder 目标文件夹
  // isOverWrite 是否覆盖目标文件
  // @Post:/copy
  static VoidApiHttp copy({required List<String> sourcePaths,required String targetFolder,required bool isOverWrite}){
    return VoidApiHttp(Api.APP_FILES_COPY).add("sourcePaths",sourcePaths).add("targetFolder",targetFolder).add("isOverWrite",isOverWrite);
  }
  // 文件移动
  // sourcePaths 源路径
  // targetFolder 目标文件夹
  // isOverWrite 是否覆盖目标文件
  // @Post:/move
  static VoidApiHttp move({required List<String> sourcePaths,required String targetFolder,required bool isOverWrite}){
    return VoidApiHttp(Api.APP_FILES_MOVE).add("sourcePaths",sourcePaths).add("targetFolder",targetFolder).add("isOverWrite",isOverWrite);
  }
  // 分享文件
  // @Post:/share
  static ReturnApiHttp<int> share({required int endDateTime,required String pwd,required String folder,required List<String> names}){
    return ReturnApiHttp<int>(Api.APP_FILES_SHARE).add("endDateTime",endDateTime).add("pwd",pwd).add("folder",folder).add("names",names);
  }
  // 文件或文件夹属性
  // paths 选择的路径列表
  // @Post:/get_property
  static ReturnApiHttp<FilePropertyModel> getProperty({required List<String> paths}){
    return ReturnApiHttp<FilePropertyModel>(Api.APP_FILES_GET_PROPERTY, FilePropertyModel.fromJson).add("paths",paths);
  }
  // 修改文件类型
  // path 文件路径
  // contentType 文件类型
  // @Post:/set_content_type
  static VoidApiHttp setContentType({required String path,required String contentType}){
    return VoidApiHttp(Api.APP_FILES_SET_CONTENT_TYPE).add("path",path).add("contentType",contentType);
  }
  //@Get:/download_history/
  static VoidApiHttp downloadByHistory({required int id}){
    return VoidApiHttp(Api.APP_FILES_DOWNLOAD_HISTORY_).add("id",id);
  }
  // 文件预览
  // dfsId dfs文件ID
  // name 文件名
  // extra 要预览的附属文件名
  // @Request:/preview/{dfsId}/{name}
  static VoidApiHttp preview({required int dfsId,required String name,required String extra}){
    return VoidApiHttp(Api.APP_FILES_PREVIEW_DFSID_NAME_).add("dfsId",dfsId).add("name",name).add("extra",extra);
  }
  // 文件下载
  // name 文件名
  // folder 所在文件夹
  // @TODO:这里应该改成文件id访问，防止客户端缓存冲突
  // @Request:/download/
  static VoidApiHttp download(){
    return VoidApiHttp(Api.APP_FILES_DOWNLOAD_);
  }
  // 缩略图下载
  // id 文件ID
  // @Request:/thumb/{id}
  static VoidApiHttp thumb({required int id}){
    return VoidApiHttp(Api.APP_FILES_THUMB_ID_).add("id",id);
  }
}