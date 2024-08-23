
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
class HttpUtilDemo{

  static final HOST = "http://127.0.0.1:8030";

  static Client? client = null;

/// 登录点击事件
  static void post(url) async {
    try {
      client = http.Client();
      final uri = Uri.parse("$HOST/app/login/do-login");
      final response = await client!.post(uri,body: {'name': "test", 'pwd': "111111"});
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print(e);
    } finally {
      client?.close();
    }
  }

  static void cancel(){
    client?.close();
  }
}