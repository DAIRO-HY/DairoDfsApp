import 'dart:math';

extension IntExtension on int? {
  /// 数据流量单位换算
  String get dataSize {
    final value = this;
    if (value == null) {
      return "0B";
    }
    if (value >= 1024 * 1024 * 1024 * 1024) {
      return "${(value / (1024 * 1024 * 1024 * 1024)).truncateTo(2)}TB";
    }
    if (value >= 1024 * 1024 * 1024) {
      return "${(value / (1024 * 1024 * 1024)).truncateTo(2)}GB";
    }
    if (value >= 1024 * 1024) {
      return "${(value / (1024 * 1024)).truncateTo(2)}MB";
    }
    if (value >= 1024) {
      return "${(value / (1024)).truncateTo(2)}KB";
    }
    return "${value}B";
  }

  /**
   * 转换成时间格式
   */
  String get timeFormat {
    if (this == null) {
      return "";
    }
    final self = this!;

    //得到时间秒
    final seconds = self / 1000;

    //小时
    final h = (seconds / (60 * 60)).toInt().toString().padLeft(2, "0");

    //分
    final m = (seconds % (60 * 60) / 60).toInt().toString().padLeft(2, "0");

    //秒
    final s = (seconds % 60).toInt().toString().padLeft(2, "0");
    if (seconds >= 60 * 60) {
      return "$h:$m:$s";
    }
    if (seconds >= 60) {
      return "$m:$s";
    }
    return "00:$s";
  }
}

extension DoubleExtension on double {
  ///舍去小数
  ///[places]保留小数位数
  double truncateTo([int places = 0]) {
    double mod = pow(10.0, places).toDouble();
    return ((this * mod).truncate().toDouble() / mod);
  }
}
