import 'package:agent/controller/socket_controller.dart';
import 'package:agent/controller/user_controller.dart';
import 'package:agent/widget/loader.dart';
import 'package:agent/widget/page_widget.dart';
import 'package:agent/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/colors.dart';
import '../routes/Routes.dart';

/// 客服
class Custom extends StatefulWidget {
  const Custom({Key? key}) : super(key: key);

  @override
  State<Custom> createState() => _CustomState();
}

class _CustomState extends State<Custom> {
  final loaderController = LoaderController();

  final socket = SocketController();

  int page = 1;

  @override
  void initState() {
    super.initState();
    loaderController.loadFinish();

    socket.setMessageBack(() {
      loaderController.loadFinish();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        showLeading: false,
        titleLabel: "客服",
        action: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ["添加好友".t.s(12).c(DSColors.white)],
          ).onTap(() {
            Get.toNamed(Routes.search);
          })
        ],
        body: Column(
          children: [getContent().expanded()],
        ));
  }

  Widget getContent() {
    return Obx(() => Loader(
          controller: loaderController,
          onRefresh: () async {
            page = 1;
            socket.getMessageList(page: page);
          },
          onLoad: () {
            page = page + 1;
            socket.getMessageList(page: page);
          },
          child: ListView.builder(
            itemCount: socket.conversationList.length,
            itemBuilder: (BuildContext context, int index) {
              final item = socket.conversationList[index];
              String title = "";

              if (item["fromid"] == UserController().user.id) {
                title = item["toname"];
              } else {
                title = item["fromname"];
              }

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      title.toString().t.s(16).c(DSColors.title),
                      (item["createdAt"] ?? "")
                          .toString()
                          .t
                          .s(14)
                          .c(DSColors.describe),
                    ],
                  ),
                  8.v,
                  Row(
                    children: [
                      "${item["fromname"]}:${item["content"] ?? "[  图片]"}"
                          .toString()
                          .t
                          .s(14)
                          .c(DSColors.subTitle)
                          .expanded(),
                      if (item["fromid"] != UserController().user.id)
                        ((item["is_read"] ?? 0) == 1 ? "已读" : "未读")
                            .t
                            .s(14)
                            .c(item["is_read"] == 0 ? Colors.green : Colors.red)
                    ],
                  ),
                ],
              )
                  .padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12))
                  .borderOnly(bottom: BorderSide(color: DSColors.divider))
                  .onTap(() {
                final id = item["fromid"] == UserController().user.id
                    ? item["toid"]
                    : item["fromid"];
                Get.toNamed(Routes.conversation, arguments: {"id": id});
              });
            },
          ),
        ));
  }
}
