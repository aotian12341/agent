import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/colors.dart';

///
class BottomShell {
  ///
  static void show(
      {required List<BottomShellItem> items, Function(int index)? onChoose}) {
    Get.bottomSheet<dynamic>(
      BottomShellView(
        items: items,
        onChoose: onChoose,
      ),
      isDismissible: false,
    );
  }
}

///
class BottomShellView extends StatefulWidget {
  ///
  const BottomShellView({
    Key? key,
    required this.items,
    this.onChoose,
  }) : super(key: key);

  ///
  final List<BottomShellItem> items;

  ///
  final Function(int index)? onChoose;

  @override
  _BottomShellViewState createState() => _BottomShellViewState();
}

class _BottomShellViewState extends State<BottomShellView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.items.length * 45 +
          MediaQueryData.fromWindow(window).padding.bottom,
      padding: EdgeInsets.only(
          bottom: MediaQueryData.fromWindow(window).padding.bottom),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        color: DSColors.white,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: widget.items.asMap().keys.map((index) {
            final item = widget.items[index];
            return InkWell(
                onTap: () {
                  if (item.tap != null) {
                    item.tap!();
                  }
                  if (widget.onChoose != null) {
                    widget.onChoose!(index);
                  }
                },
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: DSColors.divider))),
                  child: Row(
                    mainAxisAlignment:
                        item.axisAlignment ?? MainAxisAlignment.center,
                    children: [
                      if (item.icon != null) item.icon!,
                      Text(
                        item.title,
                        style: TextStyle(color: DSColors.title),
                      ),
                    ],
                  ),
                ));
          }).toList(),
        ),
      ),
    );
  }
}

///
class BottomShellItem {
  /// 标题
  String title;

  /// 图标
  Widget? icon;

  /// 点击
  Function()? tap;

  /// 对齐
  MainAxisAlignment? axisAlignment;

  ///
  BottomShellItem({
    required this.title,
    this.icon,
    this.tap,
    this.axisAlignment,
  });
}
