import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:agent/common/time_helper.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/m_toast.dart';

class Utils {
  static cacheValue(String key, dynamic value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (value.runtimeType == String) {
      sp.setString(key, value);
    } else if (value.runtimeType == double) {
      sp.setDouble(key, value);
    } else if (value.runtimeType == int) {
      sp.setInt(key, value);
    } else if (value.runtimeType == bool) {
      sp.setBool(key, value);
    } else if (value.runtimeType == List<String>) {
      sp.setStringList(key, value);
    }
  }

  static Future<dynamic> getCacheValue(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.get(key);
  }

  static double getBottom(BuildContext context) {
    return MediaQueryData.fromWindow(window).padding.bottom == 0
        ? 12
        : MediaQueryData.fromWindow(window).padding.bottom;
  }

  static List<String> getGroups(List<String> array, int m) {
    return Pailie().main(array, m);

    /*
    List<String> temp = [];

    for (final a in array) {
      temp.add("");
    }
    combination(temp, array, 0, 0);
    temp[array.length - 1] =
        array[array.length - 1][array[array.length - 1].length - 1];
    print(temp);

     */
  }

  static void combination(
      List<String> temp, List<List<String>> array, int i, int j) {
    for (; i < array.length; i++) {
      for (; j < array[i].length; j++) {
        temp[i] = array[i][j];
        //System.out.println(temp[i]);
        combination(temp, array, i + 1, 0);
        if (j + 1 < array[i].length) {
          print(temp);
        }
      }
    }
  }

  static String getToday() {
    final now = DateTime.now();
    final temp =
        DateTime.now().copyWith(hour: 6, minute: 0, second: 0, millisecond: 0);
    if (now.difference(temp).inHours > 0) {
      return now.format(format: "yyyy-MM-dd");
    } else {
      return now.subtract(const Duration(days: 1)).format(format: "yyyy-MM-dd");
    }
  }

  static bool isPc(BuildContext context) {
    return !kIsWeb &&
        (MediaQuery.of(context).size.width >
            MediaQuery.of(context).size.height);
  }

  static double formatNum(num number, int length) {
    final haha = number.toDouble();
    final temp = haha.toString().lastIndexOf(".") + length;
    if (temp > haha.toString().length) {
      return haha;
    } else {
      return Decimal.parse(haha.toString().substring(0, temp)).toDouble();
    }
  }

  static String getFileSize(num size) {
    String res = "";

    if (size < 1024) {
      res = size.toStringAsFixed(2) + "B";
    } else {
      size = size / 1024;
      if (size < 1024) {
        res = size.toStringAsFixed(2) + "KB";
      } else {
        size = size / 1024;
        if (size < 1024) {
          res = size.toStringAsFixed(2) + "MB";
        } else {
          size = size / 1024;
          res = size.toStringAsFixed(2) + "GB";
        }
      }
    }
    return res;
  }

  static Future<dynamic> saveImage({required String url}) async {
    // 申请权限
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    if (statuses[Permission.storage] == PermissionStatus.granted) {
      var response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes));
      final result =
          await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));

      if (Platform.isIOS) {
        if (result) {
          MToast.show('保存成功');
        } else {
          MToast.show('保存失败');
        }
      } else {
        if (result != null) {
          MToast.show('保存成功');
        } else {
          MToast.show('保存失败');
        }
      }
    } else {
      MToast.show('权限申请被拒绝');
    }

    /*
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    if (statuses[Permission.storage] == PermissionStatus.granted) {
      var response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name: "code");
      return result;
    } else {
      MToast.show("请设置权限");
    }
    return null;
    
     */
  }
}

class Pailie {
  int N = 4;
  int M = 3;
  List<String> a = ["1", "2", "6", "4", "5"];
  List<dynamic> b = [0, 0, 0];

  List<String> res = [];

  List<String> main(List<String> args, int M) {
    a = args;
    N = a.length;
    b = List.filled(a.length, null).map((e) => 0).toList();
    this.M = M;
    C(N, M);
    print(res);
    return res;
  }

  void C(int m, int n) {
    int i, j;
    for (i = n; i <= m; i++) {
      b[n - 1] = i - 1;
      if (n > 1) {
        C(i - 1, n - 1);
      } else {
        String str = "";
        for (j = 0; j <= M - 1; j++) {
          str += "${a[b[j]]},";
          // print(a[b[j]].toString() + "  ");
          // print("\n");
        }
        if (str.isNotEmpty) {
          str = str.substring(0, str.length - 1);
        }
        res.add(str);
      }
    }
  }
}
