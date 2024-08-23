import 'package:flutter/cupertino.dart';

import 'ApiHttp.dart';

/// 返回值允许为NULL的API请求工具
class NullApiHttp<T> extends ApiHttp<T, NullApiHttp<T>> {
  NullApiHttp(super.url, [super.fromJson]);

  Future<void> post(Future<void> Function(T?) success,[BuildContext? context]) async{
    super.nullSuccessFunc = success;
    await super.request(context);
  }
}
