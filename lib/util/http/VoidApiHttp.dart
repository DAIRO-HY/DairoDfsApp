import 'package:flutter/cupertino.dart';

import 'ApiHttp.dart';

/// 没有返回值的API请求工具
class VoidApiHttp extends ApiHttp<Object, VoidApiHttp> {
  VoidApiHttp(super.url);

  Future<void> post(Future<void> Function() success, [BuildContext? context]) async{
    super.voidSuccessFunc = success;
    await super.request(context);
  }
}
