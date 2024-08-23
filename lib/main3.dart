import 'dart:async';


void main() async {
  await wait1();
}

Future<void> wait1() async {
  print("1-1");
  await Future.delayed(Duration(seconds: 1));
  wait2();
  print("1-2");
}

Future<void> wait2() async {
  print("2-1");
  await Future.delayed(Duration(seconds: 1));
  print("2-2");
}
