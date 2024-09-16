import 'package:intl/intl.dart';

///日期格式化
extension DateTimeExtension on DateTime? {
  ///用完立即销毁
  String format([String pattern = "yyyy-MM-dd HH:mm:ss"]) {
    if (this == null) {
      return "";
    }

    // 创建 DateFormat 对象并定义格式
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    // 将 DateTime 格式化为字符串
    String formatted = formatter.format(this!);
    return formatted;
  }
}
