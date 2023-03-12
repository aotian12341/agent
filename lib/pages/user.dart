import 'package:agent/constants/app_config.dart';
import 'package:agent/controller/user_controller.dart';
import 'package:agent/pages/children_recharge.dart';
import 'package:agent/widget/alert_dialogs.dart';
import 'package:agent/widget/key_value_view.dart';
import 'package:agent/widget/loader.dart';
import 'package:agent/widget/page_widget.dart';
import 'package:agent/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/colors.dart';
import '../routes/Routes.dart';
import 'user_manager.dart';

/// 用户
class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  final loaderController = LoaderController();

  void refresh() {
    UserController().getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        showLeading: false,
        titleLabel: "个人中心",
        action: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.refresh,
                    size: 20,
                    color: DSColors.white,
                  ),
                  4.h,
                  "刷新".t.s(12).c(DSColors.white)
                ],
              )
            ],
          ).onTap(refresh)
        ],
        body: getContent());
  }

  Widget getContent() {
    return Column(
      children: [
        getHeader(),
        getMenu().expanded(),
      ],
    ).padding(padding: const EdgeInsets.all(12));
  }

  Widget getHeader() {
    return Obx(() {
      return Row(
        children: [
          Icon(
            Icons.person_pin,
            color: DSColors.black,
            size: 50,
          ),
          12.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  "用户名:${UserController().user.username}"
                      .t
                      .s(14)
                      .c(DSColors.title),
                  4.v,
                  "额度:${UserController().user.money}".t.s(14).c(DSColors.title),
                ],
              ),
              Column(
                children: [
                  "会员到期 ".t.s(14).c(DSColors.title),
                  4.v,
                  (UserController().user.openTime ?? "")
                      .toString()
                      .t
                      .s(14)
                      .c(DSColors.title),
                ],
              )
            ],
          ).expanded()
        ],
      )
          .padding(padding: const EdgeInsets.all(12))
          .borderRadius(radius: 4)
          .border(color: DSColors.primaryColor);
    });
  }

  Widget getMenu() {
    return Obx(() {
      final temp = UserController().user.isAgent == 1;
      final titles = [];
      // titles.add({'title': '我的订单', 'tag': 'order'});
      // titles.add({'title': '充值记录', 'tag': 'recharge'});
      titles.add({'title': '修改密码', 'tag': 'password'});
      if (temp) {
        titles.add({'title': '注册报表', 'tag': 'register'});
        titles.add({'title': '充值报表', 'tag': 'rechargeRecord'});
      }

      titles.add({'title': '邀请码', 'tag': 'code'});
      titles.add({'title': '邀请记录', 'tag': 'invite'});
      if (temp) {
        titles.add({'title': '您的代理及用户', 'tag': 'agent'});
        titles.add({'title': '口令列表', 'tag': 'codeList'});
        titles.add({'title': '下级充值记录', 'tag': 'childRechargeList'});
      }
      titles.add({'title': '退出登录', 'tag': 'loginOut'});
      titles.add({'title': '版本', 'tag': 'version'});
      return SingleChildScrollView(
        child: Column(
          children: titles.asMap().keys.map((index) {
            final item = titles[index];
            final tag = item["tag"];
            final value = titles[index]["tag"] == "code"
                ? UserController().user.code
                : titles[index]["tag"] == "version"
                    ? AppConfig.version
                    : "";
            return KeyValueView(
              title: item["title"],
              value: value,
              showIcon: true,
              valueLeft: false,
              padding: 0,
              height: 45,
              onTap: () {
                if (tag == "code") {
                  Get.toNamed(Routes.code);
                } else if (tag == "recharge") {
                  Get.toNamed(Routes.rechargeList);
                } else if (tag == "password") {
                  Get.toNamed(Routes.editPassword);
                } else if (tag == "invite") {
                  Get.toNamed(Routes.inviteList);
                } else if (tag == "codeList") {
                  Get.toNamed(Routes.codeList);
                } else if (tag == "agent") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              UserManager(id: UserController().user.id)));
                } else if (tag == "loginOut") {
                  Alert.show(
                      title: "提示",
                      msg: "是否退出登录",
                      leftAction: () {
                        Navigator.pop(context);
                      },
                      rightAction: () {
                        Navigator.pop(context);
                        UserController().loginOut();
                        Get.offAllNamed(Routes.login);
                      });
                } else if (tag == "childRechargeList") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ChildrenRecharge(
                                id: UserController().user.id,
                              )));
                } else if (tag == 'register') {
                  Get.toNamed(Routes.registerList);
                } else if (tag == 'rechargeRecord') {
                  Get.toNamed(Routes.rechargeRecord);
                }
              },
            );
          }).toList(),
        ),
      );
    });
  }
}
