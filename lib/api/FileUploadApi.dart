import 'API.dart';
import '../util/http/VoidApiHttp.dart';
import '../util/http/ReturnApiHttp.dart';

class FileUploadApi {
  // 文件上传Controller
  //@Group:/app/file_upload
  // 浏览器文件上传
  // @Post:
  static VoidApiHttp upload({required String folder,required String contentType}){
    return VoidApiHttp(Api.APP_FILE_UPLOAD).add("folder",folder).add("contentType",contentType);
  }
  // ByStream 以流的方式上传文件
  // @Post:/by_stream/{md5}
  static VoidApiHttp byStream({required String md5}){
    return VoidApiHttp(Api.APP_FILE_UPLOAD_BY_STREAM_MD5_).add("md5",md5);
  }
  // GetUploadedSize 获取文件已经上传大小
  // md5 文件的MD5
  // @Post:/get_uploaded_size
  static ReturnApiHttp<int> getUploadedSize({required String md5}){
    return ReturnApiHttp<int>(Api.APP_FILE_UPLOAD_GET_UPLOADED_SIZE).add("md5",md5);
  }
  // stat 通过MD5上传
  // md5 文件md5
  // path 文件路径
  // @Post:/by_md5
  static VoidApiHttp byMd5({required String md5,required String path,required String contentType}){
    return VoidApiHttp(Api.APP_FILE_UPLOAD_BY_MD5).add("md5",md5).add("path",path).add("contentType",contentType);
  }
}