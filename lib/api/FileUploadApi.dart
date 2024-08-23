import 'API.dart';
import '../util/http/NotNullApiHttp.dart';
import '../util/http/VoidApiHttp.dart';
class FileUploadApi{

///null
static VoidApiHttp byMd5(){
 return VoidApiHttp(Api.FILE_UPLOAD_BY_MD5);
}

///获取文件已经上传大小
/// [md5] 
static NotNullApiHttp<int> getUploadedSize({required String md5}){
 return NotNullApiHttp<int>(Api.FILE_UPLOAD_GET_UPLOADED_SIZE).add("md5",md5);
}

///浏览器文件上传
static VoidApiHttp upload(){
 return VoidApiHttp(Api.FILE_UPLOAD);
}

}