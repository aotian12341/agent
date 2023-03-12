import 'package:flutter/material.dart';

/// 时间工具类
class TimeUtil {
  /// 每个月对应天数
  static const List<int> _daysInMonth = <int>[
    31,
    -1,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31,
  ];

  /// 根据年月获取月的天数
  static int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      if (isLeapYear) return 29;
      return 28;
    }
    if (month == 0) {
      month = 12;
    }
    return _daysInMonth[month - 1];
  }

  /// 得到这个月的第一天是星期几（0 是 星期日 1 是 星期一...）
  static int computeFirstDayOffset(
      int year, int month, MaterialLocalizations localizations) {
    final int weekdayFromMonday = DateTime(year, month).weekday - 1;
    final int firstDayOfWeekFromSunday = localizations.firstDayOfWeekIndex;
    final int firstDayOfWeekFromMonday = (firstDayOfWeekFromSunday - 1) % 7;
    return (weekdayFromMonday - firstDayOfWeekFromMonday) % 7;
  }

  /// 每个月前面空出来的天数
  static int numberOfHeadPlaceholderForMonth(
      int year, int month, MaterialLocalizations localizations) {
    return computeFirstDayOffset(year, month, localizations);
  }

  /// 根据当前年月份计算每个月后面空出来的天数
  static int getLastRowDaysForMonthYear(
      int year, int month, MaterialLocalizations localizations) {
    int count = 0;
    int currentMonthDays = getDaysInMonth(year, month);
    int placeholderDays =
        numberOfHeadPlaceholderForMonth(year, month, localizations);
    int rows = (currentMonthDays + placeholderDays) ~/ 7; // 向下取整
    int remainder = (currentMonthDays + placeholderDays) % 7; // 取余（最后一行的天数）
    if (remainder > 0) {
      count = 7 - remainder;
    }
    return count;
  }

  /// 根据当前年月份计算当前月份显示几行
  static int getRowsForMonthYear(
      int year, int month, MaterialLocalizations localizations,
      {int? offset}) {
    int currentMonthDays = getDaysInMonth(year, month);
    int placeholderDays =
        numberOfHeadPlaceholderForMonth(year, month, localizations);
    int rows = (currentMonthDays + placeholderDays) ~/ 7; // 向下取整
    int remainder = (currentMonthDays + placeholderDays) % 7;
    remainder -= offset ?? 0; // 取余（最后一行的天数）
    if (remainder > 0) {
      rows += 1;
    }
    return rows;
  }
}
