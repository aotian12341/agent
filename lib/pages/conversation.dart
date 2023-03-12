import 'package:agent/common/time_helper.dart';
import 'package:agent/controller/socket_controller.dart';
import 'package:agent/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../../common/utils.dart';
import '../../constants/app_config.dart';
import '../../controller/user_controller.dart';
import '../../widget/photo_view.dart';
import '../common/http_controller.dart';
import '../common/upload_helper.dart';
import '../widget/loading.dart';
import '../widget/page_widget.dart';
import '../widget/portrait.dart';

class Conversation extends StatefulWidget {
  const Conversation({Key? key}) : super(key: key);

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  final conversationList = <String>[];

  final message = TextEditingController();

  final controller = SocketController();

  final scrollController = ScrollController();

  final loading = Loading();

  final id = Get.arguments["id"] ?? 0;

  int page = 1;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.userNow = null;
  }

  @override
  void initState() {
    super.initState();

    controller.messageList.clear();
    controller.receivedMsg(id);
    // controller.getUnRead();

    controller.userNow = UserController().user.id.toString();
    controller.getMessageList(userId: id, page: page);

    Future.delayed(const Duration(milliseconds: 500), () {
      controller.messageList.stream.listen((event) {
        if (scrollController.positions.isNotEmpty &&
            controller.messageList.isNotEmpty) {
          Future.delayed(const Duration(milliseconds: 300), () {
            scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.ease,
            );
          });
        }
      });
      // scrollController.addListener(() {
      //   if (scrollController.position.maxScrollExtent <
      //       scrollController.position.pixels + 100) {
      //     page += 1;
      //     SocketController().getMessageList(userId: id, page: page);
      //   }
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: "客服",
        body: Column(
          children: [
            getMessage().expanded(),
            Row(
              children: [
                Image.asset(
                  "assets/images/ic_chat_album.png",
                  width: 30,
                ).onTap(() {
                  UploaderHelper().pickerFile(
                      context: context,
                      max: 1,
                      listener: UploadListener(
                          onCreate: (id, token) {
                            showDialog(
                                context: context, builder: (_) => loading);
                          },
                          onSuccess: (imgId, path) {
                            loading.hide();
                            controller.sendUserMessage(image: path, userId: id);
                          },
                          onError: (id, error) {},
                          onProgress: (id, pro, total) {}));
                }),
                12.h,
                Row(
                  children: [
                    TextField(
                      controller: message,
                      decoration: const InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          hintText: "请输入"),
                    ).expanded()
                  ],
                )
                    .size(height: 35)
                    .padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12))
                    .color(DSColors.white)
                    .borderRadius(radius: 8)
                    .expanded(),
                8.h,
                Image.asset(
                  "assets/images/send_img.png",
                  width: 30,
                ).center().size(width: 40).onTap(() {
                  send();
                })
              ],
            ).padding(
                padding: EdgeInsets.only(
                    left: 12,
                    right: 12,
                    top: 8,
                    bottom: 12 + Utils.getBottom(context)))
          ],
        ));
  }

  Widget getMessage() {
    return Obx(() {
      return ListView.builder(
        reverse: true,
        controller: scrollController,
        itemCount: controller.messageList.length,
        itemBuilder: (BuildContext context, int index) {
          final message = controller.messageList[index];
          final name = message["fromname"];
          final temp = message["createdAt"] ?? "";
          final dt = DateTime.parse(temp);
          final time = dt.format(format: "MM-dd HH:mm");
          final tag = message["fromid"] == UserController().user.id;
          final photo = message["photo"];
          return Row(
            mainAxisAlignment:
                tag ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8),
                child: Row(
                  textDirection: tag ? TextDirection.rtl : TextDirection.ltr,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Portrait(
                      photo: photo,
                      width: 50,
                      radius: 25,
                    ),
                    12.h,
                    Column(
                      crossAxisAlignment: tag
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        tag
                            ? ("$time  $name").t.s(14).c(DSColors.title)
                            : ("$name  $time").t.s(14).c(DSColors.title),
                        6.v,
                        (message["img"] != null
                                ? Image.network(
                                        "${AppConfig.baseUrl}/${message["img"].toString().startsWith("/") ? message.img.toString().substring(1, message["img"].toString().length) : message["img"]}")
                                    .onTap(() {
                                    showDialog(
                                        context: context,
                                        builder: (_) => DSPhotoView(
                                              images: [
                                                "${AppConfig.baseUrl}/${message["img"].toString().startsWith("/") ? message["img"].toString().substring(1, message["img"].toString().length) : message["img"]}"
                                              ],
                                              index: 0,
                                            ));
                                  })
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SelectableText(
                                        message["content"] ?? "",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: DSColors.title),
                                      ).flexible()
                                    ],
                                  ))
                            .padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, top: 4, bottom: 4))
                            .color(DSColors.white)
                            .borderRadius(radius: 12)
                      ],
                    ).flexible()
                  ],
                ).margin(
                    margin:
                        const EdgeInsets.only(left: 12, right: 12, bottom: 12)),
              )
            ],
          );
        },
      );
    });
  }

  void send() {
    if (message.text.isNotEmpty) {
      controller.sendUserMessage(msg: message.text, userId: id);
      message.text = "";
      setState(() {});
    }
  }
}
