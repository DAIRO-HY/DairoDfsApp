import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';

///日期选择器
class UCDatePickerDialog {
  ///显示
  ///[context] 上下文
  ///[title] 标题
  ///[okFun] 确认按钮回调事件
  static void show(BuildContext context,
      {String title = "选择日期", int type = PickerDateTimeType.kYMD, required Function(DateTime value) okFun, VoidCallback? cancelFun}) {
    final picker = Picker(
      hideHeader: false,

      //头部底边线
      headerDecoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.color.outline, width: 0.5))),
      headerColor: context.color.primaryContainer,
      backgroundColor: context.color.primaryContainer,
      title: Text(title),
      textStyle: TextStyle(color: context.color.onSurface),
      selectedTextStyle: TextStyle(color: context.color.onSurface),
      adapter: DateTimePickerAdapter(
          type: type,
          yearSuffix: "年",
          daySuffix: "日",
          hourSuffix: "时",
          minuteSuffix: "分",
          secondSuffix: "秒",
          months: List.generate(12, (it) => (it + 1).toString() + "月") // 自定义中文月份
          ),
      cancelText: "取消",
      cancelTextStyle: TextStyle(color: context.color.onSurface),
      confirmText: "确定",
      confirmTextStyle: TextStyle(color: context.color.onSurface),
      onConfirm: (Picker picker, List value) {
        okFun((picker.adapter as DateTimePickerAdapter).value!);
      },
    );
    picker.showModal(context, builder: (context, view) {
      return Material(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          child: Container(
            padding: const EdgeInsets.only(top: 4),
            child: view,
          ));
    });
  }
}
