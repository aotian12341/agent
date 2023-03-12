import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

enum MToasts {
  ///
  LENGTH_SHORT,

  ///
  LENGTH_LONG
}

enum VGravity {
  TOP,
  BOTTOM,
  CENTER,
  TOP_LEFT,
  TOP_RIGHT,
  BOTTOM_LEFT,
  BOTTOM_RIGHT,
  CENTER_LEFT,
  CENTER_RIGHT,
  SNACKBAR
}

class MToast {
  static show(String msg,
      {MToasts? toastLength,
      VGravity? gravity,
      Color? color,
      Color? backgroundColor,
      double? fontSize}) {
    // Fluttertoast.showToast(
    //     msg: msg,
    //     toastLength: Toast.values[(toastLength ?? MToasts.LENGTH_SHORT).index],
    //     gravity: ToastGravity.values[(gravity ?? VGravity.BOTTOM).index],
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: backgroundColor,
    //     textColor: color,
    //     fontSize: fontSize);
    showToast(msg);
  }
}
