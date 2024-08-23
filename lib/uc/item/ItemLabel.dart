import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';

import 'ItemBase.dart';

///条目Label
class ItemLabel extends ItemBase {
  ItemLabel(super.label, {super.key, super.icon, super.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 8),
        child: Container(
            height: ItemBase.HEIGHT,
            padding: const EdgeInsets.only(right: 8),
            decoration: this.isShowLine
                ? const BoxDecoration(border: Border(bottom: BorderSide(color: Color(ItemBase.BORDER_LINE_COLOR), width: ItemBase.BORDER_LINE_WIDTH)))
                : null,
            child: Row(children: [
              super.ico(context),
              Gap(this.icon == null ? 0 : 6),
              context.textBody(this.label),
              Spacer(),
              context.textBody(this.tip, color: context.color.secondary)
            ])));
  }
}
