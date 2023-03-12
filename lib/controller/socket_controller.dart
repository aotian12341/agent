import 'dart:async';
import 'dart:convert';

import 'package:agent/controller/sound_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_config.dart';
import 'user_controller.dart';

import 'package:web_socket_channel/io.dart';

class SocketController {
  ///
  factory SocketController() => _getInstance();

  // 静态私有成员，没有初始化
  static SocketController? _instance;

  // 静态、同步、私有访问点
  static SocketController _getInstance() {
    _instance ??= SocketController._internal();
    return _instance!;
  }

  // 私有构造函数
  SocketController._internal();

  IOWebSocketChannel? channel;
  final count = 999.obs;

  final messageList = [].obs;

  final conversationList = [].obs;

  final unRead = false.obs;

  StreamSubscription? streamSubscription;

  /// 我的消息列表
  final myMessage = <String>[];

  final showReConnect = true.obs;

  late Function messageBack;

  /// 心跳参数
  int heartbeatSend = 0;
  int heartbeatRes = 0;

  /// 当前会话的会员ID
  String? userNow;

  void countDown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (count.value == 1) {
        count(999);
      } else {
        count(count.value - 1);
      }
      countDown();
    });
  }

  Future<void> connect() async {
    final temp = streamSubscription == null;
    initSocket().then((value) {
      if (temp) {
        heartbeat();
        countDown();
      }
      getMessageList(page: 1);
    });
  }

  Future<void> initSocket() async {
    streamSubscription?.cancel();
    streamSubscription = null;

    // PluginUtils().();

    final url =
        "${AppConfig.serviceIp}?token=${(UserController().token ?? "").replaceAll("bearer ", "")}";
    // final url =
    //     "ws://api.13333.org:2028?token=${(UserController().token ?? "").replaceAll("bearer ", "")}";
    // final url =
    //     "ws://47.57.71.221:2082?token=${(UserController().token ?? "").replaceAll("bearer ", "")}";

    channel = IOWebSocketChannel.connect(Uri.parse(url));

    showReConnect(false);
    streamSubscription = channel!.stream.listen((message) {
      showReConnect(false);
      final data = json.decode(message);
      // final base64Str = data["data"].toString();
      //
      // final cipherData = json.decode(utf8.decode(base64Decode(base64Str)));
      //
      // final iv = cipherData["iv"].toString();
      // final cipherStr = cipherData["result"].toString();
      //
      // final plaintext = AesUtil.aesDecrypt(cipherStr, iv);
      //
      // final res = json.decode(plaintext);
      // final temp = json.encode(res);
      // print("明文:$temp");
      // print(res["code"]);
      print(data);
      int code = data["code"];
      if (code == 558) {
        /// 获取最后一条消息里列表
        setAllMessage(data["data"]);
      } else if (code == 555) {
        messageList.insert(0, data["data"]["list"] ?? data["data"]);
        if (data["data"]["fromid"] != UserController().user.id &&
            userNow == null) {
          SoundController().playDiDiDi();
        }
        getMessageList();
      } else if (code == 557) {
        messageList.addAll(data["data"]["list"]["data"] ?? []);
      }
    }, onError: (error) {
      showReConnect(true);
      reLogin();
    }, onDone: () {
      showReConnect(true);
      reLogin();
    });

    print("初始化完成s");
  }

  void reLogin() {
    streamSubscription?.cancel();
    streamSubscription = null;
    initSocket();
  }

  void addParams(List<int> params) {
    channel?.sink.add(params);
  }

  void dispose() {
    channel?.sink.close();
  }

  void sendMessage(String message) {
    debugPrint("发送消息：$message");
    channel?.sink.add(message);
  }

  void sendUserMessage({
    String? image,
    String? msg,
    int? userId,
  }) {
    final data = {
      "type": "wish",
      "context": image ?? msg,
      "user_id": userId.toString(),
      "contextType": (image == null ? 1 : 2).toString() //1文字 2图片,
    };
    sendMessage(json.encode(data));
  }

  void getUnRead() {
    final data = {"type": "wishNotRead"};
    sendMessage(json.encode(data));
  }

  /// 心跳40s
  void heartbeat() {
    Future.delayed(const Duration(seconds: 40), () async {
      // if (heartbeatRes >= heartbeatSend) {
      //   heartbeatSend = DateTime.now().millisecondsSinceEpoch;
      if (channel != null) {
        final data = {
          "type": "heartbeat",
        };
        sendMessage(json.encode(data));
        heartbeat();
      }
      // } else {
      //   /// 掉线，重连，如果已经进了房间，重新进
      //   reLogin();
      // }
    });
  }

  /// 心跳回调
  void setHeartbeatRes(Map<String, dynamic> data) {
    final time = data["createdAt"];
    heartbeatRes = DateTime.parse(time).millisecondsSinceEpoch;
  }

  void receivedMsg(int userId) {
    final data = {"type": "wishRead"};
    // if (userNow != null) {
    data["user_id"] = userId.toString(); //userNow!;
    // }
    sendMessage(json.encode(data));
  }

  void getMessageList({
    int? page = 1,
    int? userId,
  }) {
    final data = {"type": "wishList", "page": page};
    if ((userId ?? "").toString().isNotEmpty) {
      data["user_id"] = userId.toString();
    }
    sendMessage(json.encode(data));
  }

  /// 设置所有人的最后一条消息
  void setAllMessage(data) {
    conversationList.clear();
    conversationList.addAll(data["list"]["data"] ?? []);
    for (final info in conversationList) {
      if (info["is_read"] == 0 && info["fromid"] != UserController().user.id) {
        unRead(true);
        break;
      }
    }
    messageBack();
  }

  void setMessageBack(Function back) {
    messageBack = back;
  }
}
