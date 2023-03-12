import 'dart:io';

import 'package:agent/constants/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PluginUtils {
  String channelName = "com.test.betfs";
  late MethodChannel _channel;

  ///
  factory PluginUtils() => _getInstance();

  ///
  static PluginUtils get instance => _getInstance();

  // 静态私有成员，没有初始化
  static PluginUtils? _instance;

  // 私有构造函数
  PluginUtils._internal() {
    _channel = MethodChannel(channelName);
  }

  // 静态、同步、私有访问点
  static PluginUtils _getInstance() {
    _instance ??= PluginUtils._internal();
    return _instance!;
  }

  /// 获取端口号
  Future<void> getConnectPort() async {
    try {
      var res = await _channel.invokeMethod<dynamic>("getConnectPort");
      if (Platform.isWindows) {
        final temp = res.toString().split(":");
        AppConfig.baseUrl = "http://${temp[0]}";
        AppConfig.basePort = temp[1].toString();
      } else {
        if (res != null) {
          AppConfig.basePort = res!["port"].toString();
          AppConfig.baseUrl = "http://${res!["host"]}";
        }
      }
      res = await _channel.invokeMethod<dynamic>("getTCPPort");
      if (Platform.isWindows) {
        final temp = res.toString().split(":");
        AppConfig.serviceIp = "ws://${temp[0]}";
        AppConfig.servicePort = int.parse(temp[1].toString());
      } else {
        if (res != null) {
          AppConfig.servicePort = res!["port"] as int;
          AppConfig.serviceIp = "ws://${res!["host"]}";
        }
      }
    } catch (e) {
      debugPrint("getConnectPort_获取端口失败");
    }
  }

  Future<dynamic> getRealServiceAddress() async {
    try {
      var res = await _channel.invokeMethod<dynamic>("getConnectPort");
      if (Platform.isWindows) {
        final temp = res.toString().split(":");
        AppConfig.baseUrl = "http://${temp[0]}";
        AppConfig.basePort = temp[1].toString();
      } else {
        if (res != null) {
          AppConfig.basePort = res!["port"].toString();
          AppConfig.baseUrl = "http://${res!["host"]}";
        }
      }
      return res;
    } catch (e) {
      debugPrint("getRealServiceAddress_获取服务地址失败");
    }
    return null;
  }

  ///
  Future<dynamic> getTCPPort() async {
    try {
      final res = await _channel.invokeMethod<dynamic>("getTCPPort");
      if (Platform.isWindows) {
        final temp = res.toString().split(":");
        AppConfig.serviceIp = "ws://${temp[0]}";
        AppConfig.servicePort = int.parse(temp[1].toString());
      } else {
        if (res != null) {
          AppConfig.servicePort = res!["port"] as int;
          AppConfig.serviceIp = "ws://${res!["host"]}";
        }
      }
      return res;
    } catch (e) {
      debugPrint("getTCPPort_获取TCP地址失败");
    }
    return null;
  }
}
