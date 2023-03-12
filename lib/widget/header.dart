import 'package:agent/common/time_helper.dart';
import 'package:agent/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:get/get.dart';

import '../common/colors.dart';
import '../common/time_util.dart';

class Header extends StatelessWidget {
  Header(
      {Key? key,
      required this.callBack,
      String? start,
      String? end,
      this.currentDate,
      this.lastDate,
      int? index})
      : super(key: key) {
    if (start != null) {
      this.start(start);
    }
    if (end != null) {
      this.end(end);
    }
    if (index != null) {
      this.index(index);
    }
  }

  final String? currentDate;
  final String? lastDate;

  final Function callBack;

  final index = 0.obs;
  final start = DateTime.now().format(format: "yyyy-MM-dd").obs;
  final end = DateTime.now().format(format: "yyyy-MM-dd").obs;

  void refresh() {
    callBack(start.value, end.value, index.value);
  }

  @override
  Widget build(BuildContext context) {
    checkFirst();
    return getTimeFilter(context);
  }

  Widget getTimeFilter(BuildContext context) {
    final titles = ["今天", "昨天", "上周", "本周", "上月", "本月"];
    return Obx(() {
      return Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: titles.asMap().keys.map((i) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: index.value == i
                        ? const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xff8ec2f0), Color(0xff5177d3)])
                        : null,
                    color: index.value == i ? null : DSColors.f5,
                  ),
                  child: titles[i]
                      .toString()
                      .t
                      .s(16)
                      .c(index.value == i ? DSColors.f5 : DSColors.subTitle),
                ).onTap(() {
                  dayClick(i);
                });
              }).toList(),
            ),
          ),
          12.v,
          Row(
            children: [
              start.value.t
                  .s(14)
                  .c(DSColors.title)
                  .center()
                  .size(height: 25)
                  .borderRadius(radius: 4)
                  .color(DSColors.white)
                  .onTap(() {
                Picker(
                    adapter: DateTimePickerAdapter(
                      type: PickerDateTimeType.kYMD,
                      isNumberMonth: true,
                      yearSuffix: "年",
                      monthSuffix: "月",
                      daySuffix: "日",
                      value: DateTime.parse(start.value),
                    ),
                    confirmText: "确定",
                    cancelText: "取消",
                    confirmTextStyle:
                        TextStyle(color: DSColors.primaryColor, fontSize: 14),
                    cancelTextStyle:
                        TextStyle(color: DSColors.title, fontSize: 14),
                    onConfirm: (picker, selectIndex) {
                      DateTime temp = (picker.adapter as DateTimePickerAdapter)
                          .value!
                          .copyWith(hour: 0, minute: 0, second: 0);
                      start(temp.format(format: "yyyy-MM-dd"));
                      final endTime = DateTime.parse(end.value)
                          .copyWith(hour: 0, minute: 0, second: 0);

                      if (temp.difference(endTime).inSeconds > 0) {
                        end(start.value);
                      }

                      refresh();
                    }).showModal<dynamic>(context);
              }).expanded(),
              "至"
                  .t
                  .s(14)
                  .c(DSColors.title)
                  .padding(padding: const EdgeInsets.symmetric(horizontal: 16)),
              end.value.t
                  .s(14)
                  .c(DSColors.title)
                  .center()
                  .size(height: 25)
                  .borderRadius(radius: 4)
                  .color(DSColors.white)
                  .onTap(() {
                Picker(
                    adapter: DateTimePickerAdapter(
                      type: PickerDateTimeType.kYMD,
                      isNumberMonth: true,
                      yearSuffix: "年",
                      monthSuffix: "月",
                      daySuffix: "日",
                      value: DateTime.parse(start.value),
                    ),
                    confirmText: "确定",
                    cancelText: "取消",
                    confirmTextStyle:
                        TextStyle(color: DSColors.primaryColor, fontSize: 14),
                    cancelTextStyle:
                        TextStyle(color: DSColors.title, fontSize: 14),
                    onConfirm: (picker, selectIndex) {
                      DateTime temp = (picker.adapter as DateTimePickerAdapter)
                          .value!
                          .copyWith(hour: 0, minute: 0, second: 0);
                      end(temp.format(format: "yyyy-MM-dd"));
                      final startTime = DateTime.parse(start.value)
                          .copyWith(hour: 0, minute: 0, second: 0);

                      if (startTime.difference(temp).inSeconds > 0) {
                        start(end.value);
                      }

                      refresh();
                    }).showModal<dynamic>(context);
              }).expanded(),
              12.h,
              "查询"
                  .t
                  .s(14)
                  .c(DSColors.white)
                  .padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4))
                  .color(DSColors.primaryColor)
                  .borderRadius(radius: 4)
                  .onTap(() {
                refresh();
              })
            ],
          )
        ],
      )
          .padding(padding: const EdgeInsets.all(16))
          .color(DSColors.f5)
          .margin(margin: const EdgeInsets.only(bottom: 12));
    });
  }

  void checkFirst() {
    if (index.value == 0) {
      final now = DateTime.now();
      final temp = DateTime.now()
          .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
      if (now.difference(temp).inHours > 0) {
        start(now.format(format: "yyyy-MM-dd"));
        end(now.format(format: "yyyy-MM-dd"));
      } else {
        start(
            now.subtract(const Duration(days: 1)).format(format: "yyyy-MM-dd"));
        end(now.subtract(const Duration(days: 1)).format(format: "yyyy-MM-dd"));
      }
    }
  }

  void dayClick(int i) {
    index(i);

    final now = DateTime.now();
    if (i == 0) {
      final temp = DateTime.now()
          .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
      if (now.difference(temp).inHours > 0) {
        start(now.format(format: "yyyy-MM-dd"));
        end(now.format(format: "yyyy-MM-dd"));
      } else {
        start(
            now.subtract(const Duration(days: 1)).format(format: "yyyy-MM-dd"));
        end(now.subtract(const Duration(days: 1)).format(format: "yyyy-MM-dd"));
      }
    } else if (i == 1) {
      final temp = DateTime.now()
          .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
      if (now.difference(temp).inHours > 0) {
        start(
            now.subtract(const Duration(days: 1)).format(format: "yyyy-MM-dd"));
        end(now.subtract(const Duration(days: 1)).format(format: "yyyy-MM-dd"));
      } else {
        start(
            now.subtract(const Duration(days: 2)).format(format: "yyyy-MM-dd"));
        end(now.subtract(const Duration(days: 2)).format(format: "yyyy-MM-dd"));
      }
    } else if (i == 2) {
      final weekday = DateTime.now().weekday - 1;
      final temp = DateTime.now()
          .subtract(Duration(days: weekday))
          .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
      if (now.difference(temp).inHours > 0) {
        start(temp
            .subtract(const Duration(days: 7))
            .format(format: "yyyy-MM-dd"));
        end(temp
            .subtract(const Duration(days: 1))
            .format(format: "yyyy-MM-dd"));
      } else {
        start(temp
            .subtract(const Duration(days: 14))
            .format(format: "yyyy-MM-dd"));
        end(temp
            .subtract(const Duration(days: 8))
            .format(format: "yyyy-MM-dd"));
      }
    } else if (i == 3) {
      final weekday = DateTime.now().weekday - 1;
      final temp = DateTime.now()
          .subtract(Duration(days: weekday))
          .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
      if (now.difference(temp).inHours > 0) {
        start(temp.format(format: "yyyy-MM-dd"));
        end(temp.add(const Duration(days: 0)).format(format: "yyyy-MM-dd"));
      } else {
        start(temp
            .subtract(const Duration(days: 7))
            .format(format: "yyyy-MM-dd"));
        end(temp
            .subtract(const Duration(days: 1))
            .format(format: "yyyy-MM-dd"));
      }
    } else if (i == 4) {
      final temp = DateTime.now()
          .copyWith(day: 1, hour: 0, minute: 0, second: 0, millisecond: 0);
      if (now.difference(temp).inHours > 0) {
        final month = now.month - 1 >= 0 ? now.month - 1 : 12;
        final year = now.month - 1 >= 0 ? now.year : now.year - 1;
        start(DateTime(year, month, 1).format(format: "yyyy-MM-dd"));
        end(DateTime(year, month, TimeUtil.getDaysInMonth(year, month))
            .format(format: "yyyy-MM-dd"));
      } else {
        final month = now.month - 2 >= 0 ? now.month - 2 : (12 + now.month - 2);
        final year = now.month - 2 >= 0 ? now.year : now.year - 1;
        start(DateTime(year, month, 1).format(format: "yyyy-MM-dd"));
        end(DateTime(year, month, TimeUtil.getDaysInMonth(year, month))
            .format(format: "yyyy-MM-dd"));
      }
    } else if (i == 5) {
      final temp = DateTime.now()
          .copyWith(day: 1, hour: 0, minute: 0, second: 0, millisecond: 0);
      if (now.difference(temp).inHours > 0) {
        start(now.copyWith(day: 1).format(format: "yyyy-MM-dd"));
        end(now
            .copyWith(day: TimeUtil.getDaysInMonth(now.year, now.month))
            .format(format: "yyyy-MM-dd"));
      } else {
        final month = now.month - 1 >= 0 ? now.month - 1 : 12;
        final year = now.month - 1 >= 0 ? now.year : now.year - 1;
        start(DateTime(year, month, 1).format(format: "yyyy-MM-dd"));
        end(DateTime(year, month, TimeUtil.getDaysInMonth(year, month))
            .format(format: "yyyy-MM-dd"));
      }
    } else if (i == 6) {
      start(DateTime.parse(currentDate!).format(format: "yyyy-MM-dd"));
      end(DateTime.parse(currentDate!).format(format: "yyyy-MM-dd"));
    } else if (i == 7) {
      start(DateTime.parse(lastDate!).format(format: "yyyy-MM-dd"));
      end(DateTime.parse(lastDate!).format(format: "yyyy-MM-dd"));
    }
    refresh();
  }
}
