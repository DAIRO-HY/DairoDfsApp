import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/uc/UCButton.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../uc/UCImage.dart';
import '../util/cache/AppCacheManager.dart';

/// 文件列表页面
class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() => ListViewPageState();
}

class ListViewPageState extends State<ListViewPage> {

  int stateValue = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: context.color.primary,
          title: Text(
            "列表测试",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body:
        Column(children: [
          Expanded(child:
          ListView.builder(
              itemCount: 1000000000000,
              itemBuilder: (context, index) {
                return UCItem(index: index);
              })),
          UCButton("按钮", onPressed: (){
            setState(() {
              this.stateValue++;
            });
          })
        ])
        );
  }
}

class UCItem extends StatelessWidget {
  final int index;
  UCItem({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
          children: [
            Text("-->index:$index ${DateTime.now()}"),
            UCImage("/d/3Ta7Nv/logo/3.jpeg?wait=1&index=${index}",width: 40, height: 40),
            //ValueListenableBuilder(valueListenable: this.thumnValueNotifier, builder: (context, value, child) => value)
            // CachedNetworkImage(imageUrl: "http://localhost:8030/d/3Ta7Nv/logo/3.jpeg?wait=1&index=${index}", width: 40, height: 40)
          ],
        );
  }
}
