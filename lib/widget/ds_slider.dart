import 'package:flutter/material.dart';

import '../common/colors.dart';

///滑块
class DSSlider extends StatefulWidget {
  ///滑块
  DSSlider({
    Key? key,
    this.value = 0,
    this.disabled = true,
    this.max = 100,
    this.min = 0,
    this.step = 0,
    this.showLabel = false,
    this.drag,
    this.change,
    this.dragStart,
    this.dragEnd,
    this.barHeight = 3,
    this.activeColor,
    this.inActiveColor,
    this.labelColor,
    this.labelSize,
    this.sliderColor,
    this.sliderSize = 20,
    this.disableColor,
  })  : assert(min < max),
        super(key: key);

  ///当前进度
  double value;

  /// 是否禁用
  bool disabled;

  /// 最大值
  double max;

  /// 最小值
  double min;

  /// 步长
  int step;

  ///是否显示进度
  bool showLabel;

  /// 进度条高度
  double barHeight;

  /// 进度条前景色
  Color? activeColor;

  /// 进度条背景色
  Color? inActiveColor;

  ///进度文字颜色
  Color? labelColor;

  ///进度文字大小
  double? labelSize;

  ///滑块颜色
  Color? sliderColor;

  ///滑块大小
  double sliderSize;

  ///禁用颜色
  Color? disableColor;

  ///拖动进度条时触发
  Function(double? value)? drag;

  ///进度值改变后触发
  Function(double? value)? change;

  ///开始拖动时触发
  Function(double? value)? dragStart;

  ///结束拖动时触发
  Function(double? value)? dragEnd;

  @override
  State<StatefulWidget> createState() => _DSSliderState();
}

class _DSSliderState extends State<DSSlider> {
  double width = 0;
  double height = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, container) {
      width = container.maxWidth;
      height = container.maxHeight;

      final Color activeColor = widget.disabled
          ? widget.activeColor ?? DSColors.primaryColor
          : DSColors.divider;
      final Color inActiveColor = widget.disabled
          ? widget.inActiveColor ?? DSColors.divider
          : DSColors.divider;

      final double value = widget.value == 0
          ? 0
          : (widget.value - widget.min) / (widget.max - widget.min) * 100;

      double sliderWidth = widget.sliderSize;
      double sliderHeight = widget.sliderSize;

      return GestureDetector(
        onTapDown: (pos) {
          _change(pos.localPosition);
          if (widget.dragStart != null) {
            widget.dragStart!(widget.value);
          }
        },
        onHorizontalDragEnd: (pos) {
          if (widget.dragEnd != null) {
            widget.dragEnd!(widget.value);
          }
        },
//        onTapUp: (pos) {
//        },
        onHorizontalDragUpdate: (pos) {
          _change(pos.localPosition);
          if (widget.drag != null) {
            widget.drag!(widget.value);
          }
          if (widget.change != null) {
            widget.change!(widget.value);
          }
        },
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              Positioned(
                left: sliderWidth / 2,
                right: sliderWidth / 2,
                top: (height - widget.barHeight) / 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: inActiveColor,
                    borderRadius: BorderRadius.circular(widget.barHeight / 2),
                  ),
                  width: width - sliderWidth,
                  height: widget.barHeight,
                ),
              ),
              Positioned(
                  left: sliderWidth / 2,
                  width: value / 100 * (width - sliderWidth),
                  top: (height - widget.barHeight) / 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: activeColor,
                      borderRadius: BorderRadius.circular(widget.barHeight / 2),
                    ),
                    width: value / 100 * (width - sliderWidth),
                    height: widget.barHeight,
                  )),
              Positioned(
                top: (height - sliderHeight) / 2,
                left: value / 100 * (width - sliderWidth),
                child: Container(
                  width: widget.sliderSize,
                  height: widget.sliderSize,
                  decoration: BoxDecoration(
                      color: widget.sliderColor ?? DSColors.white,
                      borderRadius:
                          BorderRadius.circular(widget.sliderSize / 2)),
                  child: Center(
                    child: widget.showLabel
                        ? Text(
                            widget.value.toString(),
                            style: TextStyle(
                                color: widget.labelColor,
                                fontSize: widget.labelSize),
                          )
                        : Container(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _change(Offset localPosition) {
    if (!widget.disabled) {
      return;
    }
    final double dx = localPosition.dx;
    double value = dx / width * (widget.max - widget.min);

    if (widget.step != 0) {
      double cha = value + widget.min - widget.value;
      if (cha > 0) {
        if (cha < widget.step / 2) {
          return;
        } else {
          value = widget.value + widget.step;
        }
      } else {
        if (-cha < widget.step / 2) {
          return;
        } else {
          value = widget.value - widget.step;
        }
      }
    }

    widget.value = widget.min + value;
    widget.value = double.parse(widget.value.toStringAsFixed(2));
    if (widget.value > widget.max) {
      widget.value = widget.max;
    }
    if (widget.value < widget.min) {
      widget.value = widget.min;
    }
    setState(() {});
  }
}
