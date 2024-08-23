extension AnyExtension on Object {

  /// 获取文件的SHA256
  T also<T>(void Function(T it) alsoFun){
    alsoFun(this as T);
    return this as T;
  }
}