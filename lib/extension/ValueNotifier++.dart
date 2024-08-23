import 'package:flutter/cupertino.dart';

extension ValueNotifierExtension<T> on ValueNotifier<T> {

  /// 获取文件的MD5
  Widget build(Widget Function(T value) build) {
    return ValueListenableBuilder(
        valueListenable: this,
        builder: (context, value, child) {
          return build(value);
        });
  }
}
