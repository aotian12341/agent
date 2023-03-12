import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension ViewEx on Widget {
  Widget center() {
    return Center(
      child: this,
    );
  }

  Widget size({double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  Widget borderOnly(
      {BorderSide? left,
      BorderSide? right,
      BorderSide? top,
      BorderSide? bottom}) {
    if (runtimeType.toString() == "Container") {
      final widget = this as Container;
      BoxDecoration decoration = const BoxDecoration();

      final temp = (this as Container).decoration;
      if (temp != null) {
        decoration = ((this as Container).decoration as BoxDecoration);
        decoration = decoration.copyWith(
            border: Border(
                left: left ?? BorderSide.none,
                top: top ?? BorderSide.none,
                right: right ?? BorderSide.none,
                bottom: bottom ?? BorderSide.none));
      } else {
        decoration = BoxDecoration(
            border: Border(
                left: left ?? BorderSide.none,
                top: top ?? BorderSide.none,
                right: right ?? BorderSide.none,
                bottom: bottom ?? BorderSide.none));
      }

      return Container(
        child: widget.child,
        decoration: decoration,
        padding: widget.padding,
        margin: widget.margin,
      );
    } else {
      return Container(
        decoration: BoxDecoration(
            border: Border(
                left: left ?? BorderSide.none,
                top: top ?? BorderSide.none,
                right: right ?? BorderSide.none,
                bottom: bottom ?? BorderSide.none)),
        child: this,
      );
    }
  }

  Widget border({Color? color, double? width}) {
    if (runtimeType.toString() == "Container") {
      final widget = this as Container;
      BoxDecoration decoration = const BoxDecoration();

      final temp = (this as Container).decoration;
      if (temp != null) {
        decoration = ((this as Container).decoration as BoxDecoration);
        decoration = decoration.copyWith(
            border:
                Border.all(color: color ?? Colors.black, width: width ?? 1.0));
      } else {
        decoration = BoxDecoration(
            border:
                Border.all(color: color ?? Colors.black, width: width ?? 1.0));
      }

      return Container(
        child: widget.child,
        decoration: decoration,
        padding: widget.padding,
        margin: widget.margin,
      );
    } else {
      return Container(
        decoration: BoxDecoration(
            border:
                Border.all(color: color ?? Colors.black, width: width ?? 1.0)),
        child: this,
      );
    }
  }

  Widget borderRadius({required double radius}) {
    if (runtimeType.toString() == "Container") {
      final widget = this as Container;
      BoxDecoration decoration = const BoxDecoration();

      final temp = (this as Container).decoration;
      if (temp != null) {
        decoration = ((this as Container).decoration as BoxDecoration);
        decoration =
            decoration.copyWith(borderRadius: BorderRadius.circular(radius));
      } else {
        decoration = BoxDecoration(borderRadius: BorderRadius.circular(radius));
      }

      return Container(
        child: widget.child,
        decoration: decoration,
        padding: widget.padding,
        margin: widget.margin,
      );
    } else if (runtimeType.toString() == "Image") {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: this,
      );
    } else {
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
        child: this,
      );
    }
  }

  Widget color(Color color) {
    if (runtimeType.toString() == "Container") {
      final widget = this as Container;
      BoxDecoration decoration = const BoxDecoration();

      final temp = (this as Container).decoration;
      if (temp != null) {
        decoration = ((this as Container).decoration as BoxDecoration);
        decoration = decoration.copyWith(color: color);
      } else {
        decoration = BoxDecoration(color: color);
      }

      return Container(
        child: widget.child,
        decoration: decoration,
        padding: widget.padding,
        margin: widget.margin,
      );
    } else {
      return Container(
        decoration: BoxDecoration(color: color),
        child: this,
      );
    }
  }

  Widget max({double? width, double? height}) {
    if (runtimeType.toString() == "Container") {
      final widget = this as Container;
      BoxConstraints constraints = const BoxConstraints();

      final temp = (this as Container).constraints;
      if (temp != null) {
        constraints = ((this as Container).constraints as BoxConstraints);
        constraints = constraints.copyWith(maxWidth: width, maxHeight: height);
      } else {
        constraints = constraints.copyWith(maxWidth: width, maxHeight: height);
      }

      return Container(
        child: widget.child,
        constraints: constraints,
        padding: widget.padding,
        margin: widget.margin,
      );
    } else {
      return Container(
        constraints: BoxConstraints(
          maxWidth: width ?? 0,
          maxHeight: height ?? 0,
        ),
        child: this,
      );
    }
  }

  Widget min({double? width, double? height}) {
    if (runtimeType.toString() == "Container") {
      final widget = this as Container;
      BoxConstraints constraints = const BoxConstraints();

      final temp = (this as Container).constraints;
      if (temp != null) {
        constraints = ((this as Container).constraints as BoxConstraints);
        constraints = constraints.copyWith(minWidth: width, minHeight: height);
      } else {
        constraints = constraints.copyWith(minWidth: width, minHeight: height);
      }

      return Container(
        child: widget.child,
        constraints: constraints,
        padding: widget.padding,
        margin: widget.margin,
      );
    } else {
      return Container(
        constraints: BoxConstraints(
          minWidth: width ?? 0,
          minHeight: height ?? 0,
        ),
        child: this,
      );
    }
  }

  Widget padding({EdgeInsets? padding}) {
    EdgeInsets p = EdgeInsets.zero;
    if (padding != null) {
      p = padding;
    }
    if (runtimeType.toString() == "Container") {
      final widget = this as Container;
      return Container(
        padding: p,
        decoration: widget.decoration,
        margin: widget.margin,
        child: widget.child,
      );
    } else {
      return Container(
        padding: p,
        child: this,
      );
    }
  }

  Widget margin({EdgeInsets? margin}) {
    if (runtimeType.toString() == "Container") {
      final widget = this as Container;
      return Container(
        margin: margin,
        decoration: widget.decoration,
        padding: widget.padding,
        child: widget.child,
      );
    } else {
      return Container(
        padding: margin,
        child: this,
      );
    }
  }

  Widget onTap(GestureTapCallback onTap, {bool isSame = false}) {
    return InkWell(
      onTap: onTap,
      child: GestureDetector(
        onVerticalDragEnd: isSame
            ? (details) {
                onTap();
              }
            : null,
        onHorizontalDragEnd: isSame
            ? (details) {
                onTap();
              }
            : null,
        onTapUp: (details) {
          onTap();
        },
        child: this,
      ),
    );
    // return GestureDetector(
    //   onVerticalDragEnd: (details) {
    //     onTap();
    //   },
    //   onHorizontalDragEnd: (details) {
    //     onTap();
    //   },
    //   onTapUp: (details) {
    //     onTap();
    //   },
    // );
  }

  Widget onLongPress(GestureLongPressMoveUpdateCallback longPress) {
    return GestureDetector(
      onLongPressMoveUpdate: longPress,
    );
  }

  Widget when(bool condition) {
    return condition ? this : Container();
  }

  Widget or({required Widget widget, required bool condition}) {
    return condition ? this : widget;
  }

  Widget expanded({int? flex}) {
    return Expanded(
      child: this,
      flex: flex ?? 1,
    );
  }

  Widget flexible() {
    return Flexible(child: this);
  }

  Widget obx() {
    final temp = "".obs;
    return Obx(() {
      if (temp.isEmpty) {
        String a = temp.value;
      }
      return this;
    });
  }
}

extension DecorationEx on BoxDecoration {
  BoxDecoration border({Color? color, double? width}) {
    copyWith(border: Border.all(width: width ?? 1.0, color: Colors.black));
    return this;
  }
}

extension NumEx on num {
  Widget get h => _horizontal();
  Widget get v => _vertical();

  Widget _horizontal() {
    return SizedBox(
      width: toDouble(),
    );
  }

  Widget _vertical() {
    return SizedBox(
      height: toDouble(),
    );
  }
}

extension StringEx on String {
  Text get t => text();

  Text text({double? size, Color? color}) {
    return Text(
      this,
      style: TextStyle(color: color, fontSize: size),
    );
  }
}

extension TextEx on Text {
  Text s(double size) {
    TextStyle textStyle = style ?? const TextStyle();
    textStyle = textStyle.copyWith(fontSize: size);

    return Text(
      data!,
      style: textStyle,
      key: key,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  Text c(Color color) {
    TextStyle textStyle = style ?? const TextStyle();
    textStyle = textStyle.copyWith(color: color);

    return Text(
      data!,
      style: textStyle,
      key: key,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  Text w({FontWeight? weight}) {
    TextStyle textStyle = style ?? const TextStyle();
    textStyle = textStyle.copyWith(fontWeight: weight ?? FontWeight.bold);

    return Text(
      data!,
      style: textStyle,
      key: key,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }
}
