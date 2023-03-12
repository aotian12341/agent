import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/colors.dart';

///
class MTabBar extends StatefulWidget {
  ///
  const MTabBar({
    Key? key,
    required this.titles,
    required this.onChange,
    this.cellWidth,
    this.spacing,
    this.index = 0,
    this.activeColor,
  }) : super(key: key);

  /// 标题列表
  final List<String> titles;

  /// 回调
  final Function(int index) onChange;

  /// 展示索引
  final int index;

  ///
  final double? cellWidth;
  final double? spacing;

  final Color? activeColor;

  @override
  _MTabBarState createState() => _MTabBarState();
}

class _MTabBarState extends State<MTabBar> {
  final tabIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    if (tabIndex.value != widget.index) {
      Future.delayed(const Duration(milliseconds: 300), () {
        tabIndex(widget.index);
      });
    }

    return Obx(() {
      print(tabIndex);
      if (widget.titles.isEmpty) {
        return Container();
      }
      final list = widget.titles.asMap().keys.map((index) {
        return InkWell(
          onTap: () {
            tabIndex(index);
            widget.onChange(index);
          },
          child: Container(
            constraints: BoxConstraints(minWidth: widget.cellWidth ?? 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.titles[index],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: tabIndex.value == index
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: tabIndex.value == index
                        ? widget.activeColor ?? DSColors.primaryColor
                        : DSColors.subTitle,
                  ),
                ),
                const SizedBox(height: 4),
                if (index == tabIndex.value)
                  Container(
                    width: 20,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: widget.activeColor ?? DSColors.primaryColor,
                    ),
                  )
              ],
            ),
          ),
        );
      }).toList();
      if (widget.titles.length < 4) {
        return Container(
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: list,
          ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: widget.spacing ?? 48,
              children: list,
            ),
          ),
        );
      }
    });
  }
}
