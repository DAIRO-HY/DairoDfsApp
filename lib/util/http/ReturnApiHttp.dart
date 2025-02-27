import 'package:flutter/cupertino.dart';

import 'ApiHttp.dart';

/// 返回值不允许为NULL的API请求工具
class ReturnApiHttp<T> extends ApiHttp<T, ReturnApiHttp<T>> {
  ReturnApiHttp(super.url, [super.fromJson]);

  ///发起post请求
  Future<void> post(Future<void> Function(T) success,[BuildContext? context]) async{
    super.returnSuccessFunc = success;
    await super.request(context);
  }
}
