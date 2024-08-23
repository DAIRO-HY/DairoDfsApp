import 'package:flutter/material.dart';

abstract class StateBase1<T extends StatefulWidget> extends State<T> {

  @override
  Widget build(BuildContext context) {
    return this.create(context);
  }

  Widget create(BuildContext context);

  @override
  initState() {
    super.initState();
  }

  ///页面被销毁时
  @override
  dispose() {
    super.dispose();
  }
}
