import 'package:agent/controller/user_controller.dart';
import 'package:agent/controller/video_controller.dart';
import 'package:agent/widget/bottom_shell.dart';
import 'package:agent/widget/key_input_view.dart';
import 'package:agent/widget/m_toast.dart';
import 'package:agent/widget/page_widget.dart';
import 'package:agent/widget/view_ex.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../common/colors.dart';
import '../routes/Routes.dart';
import '../widget/alert_dialogs.dart';
import '../widget/loader.dart';

class VideoDetailss extends StatefulWidget {
  const VideoDetailss({Key? key}) : super(key: key);

  @override
  State<VideoDetailss> createState() => _VideoDetailssState();
}

class _VideoDetailssState extends State<VideoDetailss> {
  final data = Get.arguments;

  final video = {}.obs;

  final loaderController = LoaderController();

  VideoPlayerController? videoPlayerController;

  ChewieController? chewieController;

  bool showDialogs = false;

  final planList = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      getData();
    });
  }

  void init(String path) {
    videoPlayerController = VideoPlayerController.network(path)
      ..initialize().then((value) {});
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      // 比例
      aspectRatio: 16 / 9,
      // 循环
      looping: true,
    );

    videoPlayerController?.play();

    setState(() {});
  }

  void showAlert() {
    videoPlayerController?.pause();
    Alert.show(
        canCancel: false,
        title: "提示",
        msg: "注册后再观看",
        leftText: "注册",
        rightText: "登录",
        actionHidden: false,
        leftAction: () {
          Navigator.pop(context);
          Get.offAndToNamed(Routes.register);
        },
        rightAction: () {
          Navigator.pop(context);
          Get.offAndToNamed(Routes.login);
        });
  }

  void getData() {
    VideoController().getVideoDetails(
        id: data["id"],
        success: (res) {
          video(res["list"] ?? {});

          init(video["path"]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        body: Column(
      children: [
        getVideo(),
        12.v,
        getDescribe(),
      ],
    ));
  }

  Widget getVideo() {
    return Obx(() {
      if (video["path"] != null) {
        return Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 9 / 16,
            color: Colors.black26,
            child: chewieController == null
                ? const CircularProgressIndicator()
                : Chewie(
                    controller: chewieController!,
                  ));
      } else {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 9 / 16,
          child: Image.network(data["photo"] ?? ""),
        );
      }
    });
  }

  Widget getDescribe() {
    return Obx(() {
      final title = (video["title"] ?? "").toString();
      final describe = (video["describe"] ?? "").toString();
      return Column(
        children: [
          Row(
            children: [
              "正在播放".t.s(16).c(DSColors.title).size(width: 80),
              12.h,
              title.t.s(16).c(DSColors.title).expanded()
            ],
          ),
          12.v,
          Row(
            children: [
              "简介".t.s(16).c(DSColors.title).size(width: 80),
              12.h,
              describe.t.s(16).c(DSColors.title).center().expanded()
            ],
          )
        ],
      )
          .borderRadius(radius: 8)
          .border(color: DSColors.describe)
          .padding(padding: const EdgeInsets.all(12))
          .margin(margin: const EdgeInsets.all(12));
    });
  }
}
