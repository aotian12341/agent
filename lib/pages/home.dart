import 'package:agent/controller/user_controller.dart';
import 'package:agent/pages/custom.dart';
import 'package:agent/pages/user.dart';
import 'package:agent/pages/video.dart';
import 'package:agent/widget/key_value_view.dart';
import 'package:agent/widget/loader.dart';
import 'package:agent/widget/page_widget.dart';
import 'package:agent/widget/view_ex.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/colors.dart';
import '../common/version_utils.dart';
import '../controller/socket_controller.dart';
import '../routes/Routes.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final custom = const Custom();
  final user = const User();
  final video = const Video();

  final index = 0.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () {
      check(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        showAppBar: false,
        body: Column(
          children: [
            getContent().expanded(),
            getTab(),
          ],
        ));
  }

  Widget getContent() {
    return Obx(() {
      var children = <Widget>[];
      if (UserController().user.isAgent == 1) {
        children = [video, user, custom];
      } else {
        children = [video, user];
      }
      return IndexedStack(
        index: index.value,
        children: children,
      );
    });
  }

  Widget getTab() {
    return Obx(() {
      var title = [];
      if (UserController().user.isAgent == 1) {
        title = ["视频", "个人", "客服"];
      } else {
        title = ["视频", "个人"];
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: title.asMap().keys.map((i) {
          return Stack(
            children: [
              title[i]
                  .toString()
                  .t
                  .s(16)
                  .c(index.value == i ? DSColors.primaryColor : DSColors.title)
                  .onTap(() {
                if (title[i] == "个人" && UserController().user.id == null) {
                  Get.toNamed(Routes.login);
                } else {
                  index(i);
                }
              }),
              if (SocketController().unRead.value &&
                  i == title.length - 1 &&
                  UserController().user.isAgent == 1)
                Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.red),
                    ))
            ],
          ).size(width: 45).center().expanded();
        }).toList(),
      ).size(height: 50);
    });
  }

  void check(BuildContext context) {
    VersionUtils().checkVersion(
        (value) {
          if (value["update"] == 1) {
            VersionUtils().showUpdate(context, value);
          }
        },
        showLoading: true,
        fail: (error) {
          if (error == "无网络") {
            Future.delayed(const Duration(milliseconds: 1000), () {
              check(context);
            });
          }
        });
  }
}
