import 'package:flutter/cupertino.dart';

import 'ApiHttp.dart';

/// 返回值不允许为NULL的API请求工具
class NotNullApiHttp<T> extends ApiHttp<T, NotNullApiHttp<T>> {
  NotNullApiHttp(super.url, [super.fromJson]);

  ///发起post请求
  Future<void> post(Future<void> Function(T) success,[BuildContext? context]) async{
    super.notNullSuccessFunc = success;
    await super.request(context);
  }
}
