import 'package:sqlite3/sqlite3.dart';

extension DatabaseExtension<T> on Database {

  ///用完立即销毁
  T useSync(T Function(Database it) useFun){
    try {
      return useFun(this);
    }finally {
      this.dispose();
    }
  }

  ///用完立即销毁
  Future<void> use(Future<void> Function(Database it) useFun) async{
    try {
      await useFun(this);
    }finally {
      this.dispose();
    }
  }
}