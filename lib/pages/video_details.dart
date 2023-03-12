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

class VideoDetails extends StatefulWidget {
  const VideoDetails({Key? key}) : super(key: key);

  @override
  State<VideoDetails> createState() => _VideoDetailsState();
}

class _VideoDetailsState extends State<VideoDetails> {
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
      ..initialize().then((value) {
        videoPlayerController!.addListener(() {
          final uid = UserController().user.id;
          if (((videoPlayerController?.value?.position.inSeconds ?? 0) >=
                  180) &&
              uid == null &&
              (videoPlayerController?.value?.isPlaying ?? false) &&
              !showDialogs) {
            showDialogs = true;
            Future.delayed(const Duration(seconds: 1), () {
              showAlert();
            });
          }
        });
      });
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

    UserController().getUserInfo(
        check: false,
        success: (user) {
          UserController().getPlan(success: (plan) {
            planList.clear();
            planList.addAll(plan["list"] ?? []);
            UserController().getMemberTime(
                success: (res) {},
                fails: (error) {
                  Future.delayed(const Duration(seconds: 1), () {
                    videoPlayerController?.pause();
                    showPlan();
                  });
                });
          });
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

  void showPlan() {
    final titles = [];
    titles.add({"title": '分享给您的好友，填写您的邀请码，注册并充值成功，将奖励您三天观看'});
    for (final temp in planList) {
      titles.add(temp);
    }

    titles.add({"title": '获取包时观看权限'});
    titles.add({"title": '取消'});

    showDialog(
        context: context,
        builder: (_) {
          return AlertDialogs(
            canCancel: false,
            title: "",
            actionHidden: true,
            transparent: true,
            view: Column(
              children: titles.asMap().keys.map((i) {
                final item = titles[i];
                final color = i == 0
                    ? const Color(0xffb92a4f)
                    : (i == titles.length - 1 || i == titles.length - 2)
                        ? const Color(0xff3056c6)
                        : Colors.purple;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(40)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      constraints: const BoxConstraints(minHeight: 45),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          item["title"]
                              .toString()
                              .t
                              .s(20)
                              .c(DSColors.white)
                              .center()
                              .expanded()
                        ],
                      ),
                    ).onTap(() {
                      click(titles, i);
                    }).expanded()
                  ],
                );
              }).toList(),
            ),
          );
        });
  }

  void click(titles, index) {
    Navigator.pop(context);
    if (index == 0) {
      Get.offAndToNamed(Routes.code);
    } else if (index == titles.length - 1) {
      Navigator.pop(context);
    } else if (index == titles.length - 2) {
      showInput();
    } else {
      showConfirm(titles[index]);
    }
  }

  void showConfirm(item) {
    Alert.show(
        canCancel: false,
        title: '提示',
        msg: "确认选择该方案?",
        leftAction: () {
          Navigator.pop(context);
          showPlan();
        },
        rightAction: () {
          Navigator.pop(context);
          showPayment(item);
        });
  }

  void showPayment(item) {
    BottomShell.show(
        items: [BottomShellItem(title: "支付宝"), BottomShellItem(title: "取消")],
        onChoose: (index) {
          if (index == 1) {
            Navigator.pop(context);
            showPlan();
            return;
          }
          UserController().recharge(
              money: item["money"] ?? 0,
              type: item["id"],
              success: (res) async {
                showAliPay(res);
                // final temp = res.toString().split(" ");
                // String url = "";
                // for (final str in temp) {
                //   if (str.contains("action")) {
                //     url = str.replaceAll("action='", "");
                //     url = url.replaceAll("'", "");
                //     break;
                //   }
                // }
                // if (url.isNotEmpty) {
                //   if (!await launchUrl(Uri.parse(url))) {
                //     throw Exception('Could not launch $url');
                //   }
                // } else {
                //   MToast.show("充值失败，稍后再试");
                // }
              });
        });
  }

  final webController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00ff0000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {
          print("ccccccccccc");
          print(url);
        },
        onPageFinished: (String url) {
          print("bbbbbbbb");
          print(url);
        },
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          print("aaaaaaaaaa");
          print(request.url);
          if (request.url.contains("alipays://")) {
            launchUrl(Uri.parse(request.url));
            return NavigationDecision.prevent;
          }
          // if (request.url.startsWith('alipays')) {
          //   launchUrl(Uri.parse(request.url));

          // }
          return NavigationDecision.navigate;
        },
      ),
    );

  void showAliPay(html) {
    Get.bottomSheet(Column(
      children: [WebViewWidget(controller: webController).expanded()],
    ).size(height: MediaQuery.of(context).size.height / 2));
    Future.delayed(const Duration(milliseconds: 500), () {
      webController.loadHtmlString(html);
    });
  }

  final code = TextEditingController();
  void showInput() {
    Alert.show(
        canCancel: false,
        title: "请输入口令",
        view: KeyInputView(
          title: "口令",
          hint: "请输入口令",
          controller: code,
        ),
        leftAction: () {
          Navigator.pop(context);
          showPlan();
        },
        rightAction: () {
          if (code.text.isEmpty) {
            MToast.show("请输入口令");
            return;
          }
          UserController().useCode(
              code: code.text,
              success: (res) {
                Navigator.pop(context);
                Navigator.pop(context);
              });
        });
  }
}
