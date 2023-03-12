/// 时间扩展
extension NumTimeExtension<T extends num> on T {
  /// 周数
  Duration get weeks => days * DurationTimeExtension.daysPerWeek;

  /// 天数
  Duration get days => milliseconds * Duration.millisecondsPerDay;

  /// 时数
  Duration get hours => milliseconds * Duration.millisecondsPerHour;

  /// 分数
  Duration get minutes => milliseconds * Duration.millisecondsPerMinute;

  /// 秒数
  Duration get seconds => milliseconds * Duration.millisecondsPerSecond;

  /// 毫秒数
  Duration get milliseconds => Duration(
      microseconds: (this * Duration.microsecondsPerMillisecond).toInt());

  /// 微妙数
  Duration get microseconds =>
      milliseconds ~/ Duration.microsecondsPerMillisecond;

  /// 纳秒数
  Duration get nanoseconds =>
      microseconds ~/ DurationTimeExtension.nanosecondsPerMicrosecond;
}

/// 时间扩展
extension DateTimeTimeExtension on DateTime {
  /// 格式化
  String _comFormat(
    int value,
    String format,
    String single,
    String full,
  ) {
    var result = format;
    if (result.contains(single)) {
      if (result.contains(full)) {
        result = result.replaceAll(
          full,
          value < 10 ? '0$value' : value.toString(),
        );
      } else {
        result = result.replaceAll(single, value.toString());
      }
    }
    return result;
  }

  /// 格式化
  String format({String? format}) {
    var result = format ?? 'yyyy-MM-dd HH:mm:ss';
    if (result.contains('yy')) {
      final String year = this.year.toString();
      if (result.contains('yyyy')) {
        result = result.replaceAll('yyyy', year);
      } else {
        result = result.replaceAll(
            'yy', year.substring(year.length - 2, year.length));
      }
    }
    result = _comFormat(this.month, result, 'M', 'MM');
    result = _comFormat(this.day, result, 'd', 'dd');
    result = _comFormat(this.hour, result, 'H', 'HH');
    result = _comFormat(this.minute, result, 'm', 'mm');
    result = _comFormat(this.second, result, 's', 'ss');
    result = _comFormat(this.millisecond, result, 'S', 'SSS');
    return result;
  }

  /// 时间相加
  DateTime operator +(Duration duration) => add(duration);

  /// 时间相减
  DateTime operator -(Duration duration) => subtract(duration);

  /// 日期
  DateTime get date => DateTime(year, month, day);

  /// 时间
  Duration get timeOfDay => hour.hours + minute.minutes + second.seconds;

  /// 是否同年
  bool get isSameYear => isAtSameYearAs(DateTime.now());

  /// 是否同月
  bool get isSameMonth => isAtSameMonthAs(DateTime.now());

  /// 是否同日
  bool get isSameDay => isAtSameDayAs(DateTime.now());

  /// 是否同时
  bool get isSameHour => isAtSameHourAs(DateTime.now());

  /// 是否同分
  bool get isSameMinute => isAtSameMinuteAs(DateTime.now());

  /// 是否同秒
  bool get isSameSecond => isAtSameSecondAs(DateTime.now());

  /// 是否同毫秒
  bool get isSameMillisecond => isAtSameMillisecondAs(DateTime.now());

  /// 是否同微秒
  bool get isSameMicrosecond => isAtSameMicrosecondAs(DateTime.now());

  /// 是否今天
  bool get isToday {
    return _calculateDifference(this) == 0;
  }

  /// 是否明天
  bool get isTomorrow {
    return _calculateDifference(this) == 1;
  }

  /// 是否昨天
  bool get wasYesterday {
    return _calculateDifference(this) == -1;
  }

  /// 是否闰年(从1582开始)
  bool get isLeapYear =>
      year >= 1582 && year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);

  /// 当月天数
  int get daysInMonth {
    final days = [
      31, // 1月
      if (isLeapYear) 29 else 28, // 2月
      31, // 3月
      30, // 4月
      31, // 5月
      30, // 6月
      31, // 7月
      31, // 8月
      30, // 9月
      31, // 10月
      30, // 11月
      31, // 12月
    ];
    return days[month - 1];
  }

  /// 是否同年
  bool isAtSameYearAs(DateTime other) => year == other.year;

  /// 是否同月
  bool isAtSameMonthAs(DateTime other) =>
      isAtSameYearAs(other) && month == other.month;

  /// 是否同天
  bool isAtSameDayAs(DateTime other) =>
      isAtSameMonthAs(other) && day == other.day;

  /// 是否同时
  bool isAtSameHourAs(DateTime other) =>
      isAtSameDayAs(other) && hour == other.hour;

  /// 是否同分
  bool isAtSameMinuteAs(DateTime other) =>
      isAtSameHourAs(other) && minute == other.minute;

  /// 是否同秒
  bool isAtSameSecondAs(DateTime other) =>
      isAtSameMinuteAs(other) && second == other.second;

  /// 是否同毫秒
  bool isAtSameMillisecondAs(DateTime other) =>
      isAtSameSecondAs(other) && millisecond == other.millisecond;

  /// 是否同微秒
  bool isAtSameMicrosecondAs(DateTime other) =>
      isAtSameMillisecondAs(other) && microsecond == other.microsecond;

  static int _calculateDifference(DateTime date) {
    final now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  /// 开始时间到结束时间之间的Iterable<DateTime>
  Iterable<DateTime> to(
    DateTime to, {
    Duration by = const Duration(days: 1),
  }) sync* {
    if (isAtSameMomentAs(to)) {
      return;
    }
    if (isBefore(to)) {
      var value = this + by;
      yield value;
      var count = 1;
      while (value.isBefore(to)) {
        value = this + (by * ++count);
        yield value;
      }
    } else {
      var value = this - by;
      yield value;
      var count = 1;
      while (value.isAfter(to)) {
        value = this - (by * ++count);
        yield value;
      }
    }
  }

  /// 拷贝
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}

/// 时间扩展
extension DurationTimeExtension on Duration {
  /// 一周总天数
  static const int daysPerWeek = 7;

  /// 一秒总毫秒数
  static const int nanosecondsPerMicrosecond = 1000;

  /// 几周
  int get inWeeks => (inDays / daysPerWeek).ceil();

  /// 转化为日期
  DateTime get toDateTime => DateTime(0, 0, 0, 0, 0, 0, this.inMicroseconds);

  /// 与当前日期相减
  DateTime get dateTime =>
      DateTime.fromMicrosecondsSinceEpoch(this.inMicroseconds);

  /// 与当前日期相加
  DateTime get fromNow => DateTime.now() + this;

  /// 与当前日期相减
  DateTime get ago => DateTime.now() - this;

  /// 异步日期
  Future<void> get delay => Future.delayed(this);
}
