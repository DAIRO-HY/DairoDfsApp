void main() {
 ApiHttp<List<int>>();
}


/// API请求
class ApiHttp<T> {

 ///记录当前泛型类型
 final Type type;

 ApiHttp() : type = T {
  print(type == List<int>);
 }
}
