import 'dart:io';
import 'package:crypto/crypto.dart' as crypto;

extension FileExtension on File {

  /// 获取文件的MD5
  Future<String> get md5 async{
    var value = await crypto.md5.bind(this.openRead()).first;
    return value.toString();
  }

  /// 获取文件的SHA1
  Future<String> get sha1 async{
    var value = await crypto.sha1.bind(this.openRead()).first;
    return value.toString();
  }

  /// 获取文件的SHA256
  Future<String> get sha256 async{
    var value = await crypto.sha256.bind(this.openRead()).first;
    return value.toString();
  }

}
