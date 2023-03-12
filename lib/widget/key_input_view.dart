import 'package:flutter/material.dart';

import '../common/colors.dart';
import 'key_value_view.dart';

///
class KeyInputView extends StatelessWidget {
  ///
  const KeyInputView({
    Key? key,
    this.title,
    this.titleView,
    this.controller,
    this.isLeft = true,
    this.hint,
    this.hintColor,
    this.hintSize,
    this.inputType,
    this.titleColor,
    this.titleSize,
    this.valueColor,
    this.valueSize,
    this.onChange,
    this.isPassword = false,
    this.titleWidth,
    this.icon,
    this.padding = 12,
    this.showIcon,
    this.height,
    this.showBorder,
  }) : super(key: key);

  /// 左标题
  final String? title;

  /// 左组件
  final Widget? titleView;

  /// 标题宽
  final double? titleWidth;

  /// 文本框控制器
  final TextEditingController? controller;

  /// 是否左对齐
  final bool isLeft;

  /// 提示文字
  final String? hint;

  /// 提示文字大小
  final double? hintSize;

  /// 提示文字颜色
  final Color? hintColor;

  /// 输入类型
  final TextInputType? inputType;

  /// 标题颜色
  final Color? titleColor;

  /// 标题大小
  final double? titleSize;

  /// 文本框文字颜色
  final Color? valueColor;

  /// 文本框文字大小
  final double? valueSize;

  /// 边距
  final double padding;

  /// 是否密码
  final bool isPassword;

  /// 文字改变回调
  final Function(String)? onChange;

  /// icon
  final Widget? icon;
  final bool? showBorder;
  final bool? showIcon;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return KeyValueView(
      title: title,
      titleView: titleView,
      height: height,
      padding: padding,
      titleSize: titleSize ?? 16,
      titleColor: titleColor ?? DSColors.title,
      titleWidth: titleWidth,
      showBorder: showBorder ?? false,
      valueView: TextField(
        obscureText: isPassword,
        controller: controller,
        textAlign: isLeft ? TextAlign.start : TextAlign.end,
        keyboardType: inputType,
        style: TextStyle(color: valueColor ?? DSColors.title, fontSize: 16),
        maxLines: isPassword ? 1 : null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
              color: hintColor ?? DSColors.describe, fontSize: hintSize ?? 16),
        ),
        onChanged: onChange,
      ),
      showIcon: showIcon ?? false,
      icon: icon,
    );
  }
}
