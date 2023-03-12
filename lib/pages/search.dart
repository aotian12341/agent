import 'package:agent/controller/user_controller.dart';
import 'package:agent/routes/Routes.dart';
import 'package:agent/widget/key_input_view.dart';
import 'package:agent/widget/loader.dart';
import 'package:agent/widget/m_toast.dart';
import 'package:agent/widget/page_widget.dart';
import 'package:agent/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/colors.dart';

/// 搜索好友
class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final username = TextEditingController();

  final loaderController = LoaderController();

  final data = <String, dynamic>{}.obs;

  @override
  void initState() {
    super.initState();
    loaderController.loadFinish();
  }

  void refresh() {
    if (username.text.isEmpty) {
      MToast.show("请输入用户名");
    }
    loaderController.loading();
    UserController().search(
        username: username.text,
        success: (res) {
          data(res["list"]);
          loaderController.loadFinish();
        });
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: "查找代理",
        body: Column(
          children: [
            getSearch(),
            getContent().expanded(),
          ],
        ));
  }

  Widget getSearch() {
    return KeyInputView(
      title: "用户名",
      hint: "请输入用户名",
      controller: username,
      showIcon: true,
      icon: "查询"
          .t
          .c(DSColors.white)
          .center()
          .size(width: 60, height: 30)
          .color(DSColors.primaryColor)
          .borderRadius(radius: 4)
          .onTap(refresh),
    );
  }

  Widget getContent() {
    return Obx(() => Loader(
          controller: loaderController,
          child: SingleChildScrollView(
            child: (data["id"] ?? "").toString().isEmpty
                ? Container()
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "用户名:${data["username"] ?? ''}"
                              .toString()
                              .t
                              .s(16)
                              .c(DSColors.title),
                          "昵称:${data["cnname"] ?? ''}"
                              .toString()
                              .t
                              .s(16)
                              .c(DSColors.title),
                        ],
                      ),
                      12.v,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          "发起聊天"
                              .t
                              .s(14)
                              .c(DSColors.white)
                              .center()
                              .size(width: 60, height: 30)
                              .color(DSColors.primaryColor)
                              .borderRadius(radius: 4)
                              .onTap(() {
                            Get.toNamed(Routes.conversation,
                                arguments: {"id": data["id"]});
                          })
                        ],
                      )
                    ],
                  )
                    .padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12))
                    .border(color: DSColors.primaryColor)
                    .borderRadius(radius: 8)
                    .margin(margin: EdgeInsets.all(12)),
          ),
        ));
  }
}
