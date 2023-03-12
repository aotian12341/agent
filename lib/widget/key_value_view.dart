import 'package:flutter/material.dart';

import '../common/colors.dart';

///
class KeyValueView extends StatelessWidget {
  ///
  const KeyValueView({
    Key? key,
    this.height,
    this.width = double.infinity,
    this.padding = 12,
    this.titleWidth = 86,
    this.title,
    this.titleColor,
    this.titleSize,
    this.value,
    this.valueColor,
    this.valueSize,
    this.titleView,
    this.valueView,
    this.showBorder = true,
    this.showIcon = false,
    this.valueLeft = true,
    this.icon,
    this.onTap,
  }) : super(key: key);

  /// 高
  final double? height;

  /// 宽
  final double width;

  /// 内边距
  final double padding;

  /// 标题
  final String? title;

  /// 标题最小宽
  final double? titleWidth;

  /// 标题颜色
  final Color? titleColor;

  /// 标题文字大小
  final double? titleSize;

  /// 右文字
  final String? value;

  /// 右文字颜色
  final Color? valueColor;

  /// 右文字大小
  final double? valueSize;

  /// 左组件
  final Widget? titleView;

  /// 右组件
  final Widget? valueView;

  /// 是否显示图标
  final bool showIcon;

  /// 自定义图标
  final Widget? icon;

  /// 是否显示边框
  final bool showBorder;

  /// 右侧文字是否左对齐
  final bool valueLeft;

  /// 点击
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
          border: showBorder
              ? Border(bottom: BorderSide(width: 0.5, color: DSColors.describe))
              : null,
        ),
        constraints: BoxConstraints(minHeight: height ?? 48),
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Row(
          children: [
            titleView ??
                Container(
                  constraints: BoxConstraints(
                    minWidth: titleWidth ?? 86,
                  ),
                  child: Text(
                    title ?? "",
                    style: TextStyle(fontSize: titleSize, color: titleColor),
                  ),
                ),
            Expanded(
              child: Row(
                textDirection:
                    valueLeft ? TextDirection.ltr : TextDirection.rtl,
                children: [
                  Flexible(
                    child: valueView ??
                        Text(
                          value ?? "",
                          style:
                              TextStyle(fontSize: valueSize, color: valueColor),
                        ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (showIcon)
              icon ??
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 30,
                    color: DSColors.describe,
                  ),
          ],
        ),
      ),
    );
  }
}
