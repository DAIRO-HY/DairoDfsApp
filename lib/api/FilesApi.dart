import 'API.dart';
import '../util/http/NotNullApiHttp.dart';
import '../util/http/VoidApiHttp.dart';
import 'model/FilePropertyModel.dart';
import 'model/FileModel.dart';
import '../util/http/ApiHttp.dart';
class FilesApi{

///文件复制
/// [sourcePaths] 源路径
/// [targetFolder] 目标文件夹
/// [isOverWrite] 是否覆盖目标文件
static VoidApiHttp copy({required List<String> sourcePaths, required String targetFolder, required bool isOverWrite}){
 return VoidApiHttp(Api.FILES_COPY).add("sourcePaths",sourcePaths).add("targetFolder",targetFolder).add("isOverWrite",isOverWrite);
}

///创建文件夹
/// [folder] 文件夹名
static VoidApiHttp createFolder({required String folder}){
 return VoidApiHttp(Api.FILES_CREATE_FOLDER).add("folder",folder);
}

///删除文件
/// [paths] 要删除的文件路径数组
static VoidApiHttp delete({required List<String> paths}){
 return VoidApiHttp(Api.FILES_DELETE).add("paths",paths);
}

///获取扩展文件的所有key值
/// [id] 
static NotNullApiHttp<List<String>> getExtraKeys({required int id}){
 return NotNullApiHttp<List<String>>(Api.FILES_GET_EXTRA_KEYS,StringExt.fromJsonList).add("id",id);
}

///获取文件列表
/// [folder] 
static NotNullApiHttp<List<FileModel>> getList({required String folder}){
 return NotNullApiHttp<List<FileModel>>(Api.FILES_GET_LIST,FileModel.fromJsonList).add("folder",folder);
}

///文件或文件夹属性
/// [paths] 选择的路径列表
static NotNullApiHttp<FilePropertyModel> getProperty({required List<String> paths}){
 return NotNullApiHttp<FilePropertyModel>(Api.FILES_GET_PROPERTY,FilePropertyModel.fromJson).add("paths",paths);
}

///文件移动
/// [sourcePaths] 源路径
/// [targetFolder] 目标文件夹
/// [isOverWrite] 是否覆盖目标文件
static VoidApiHttp move({required List<String> sourcePaths, required String targetFolder, required bool isOverWrite}){
 return VoidApiHttp(Api.FILES_MOVE).add("sourcePaths",sourcePaths).add("targetFolder",targetFolder).add("isOverWrite",isOverWrite);
}

///重命名
/// [sourcePath] 源路径
/// [name] 新名称
static VoidApiHttp rename({required String sourcePath, required String name}){
 return VoidApiHttp(Api.FILES_RENAME).add("sourcePath",sourcePath).add("name",name);
}

///修改文件类型
/// [path] 文件路径
/// [contentType] 文件类型
static VoidApiHttp setContentType({required String path, required String contentType}){
 return VoidApiHttp(Api.FILES_SET_CONTENT_TYPE).add("path",path).add("contentType",contentType);
}

///分享文件
/// [endDateTime] 分享结束时间戳,0代表永久有效
/// [pwd] 分享密码
/// [folder] 分享的文件夹
/// [names] 要分享的文件名或文件夹名列表
static NotNullApiHttp<int> share({required int endDateTime, String? pwd, required String folder, required List<String> names}){
 return NotNullApiHttp<int>(Api.FILES_SHARE).add("endDateTime",endDateTime).add("pwd",pwd).add("folder",folder).add("names",names);
}

}