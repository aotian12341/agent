import 'package:agent/controller/user_controller.dart';
import 'package:agent/widget/alert_dialogs.dart';
import 'package:agent/widget/key_input_view.dart';
import 'package:agent/widget/key_value_view.dart';
import 'package:agent/widget/page_widget.dart';
import 'package:agent/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/colors.dart';
import '../widget/m_toast.dart';

/// 用户编辑
class UserEdit extends StatefulWidget {
  const UserEdit({Key? key}) : super(key: key);

  @override
  State<UserEdit> createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  final id = Get.arguments?["id"];

  final username = TextEditingController();
  final cnname = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();

  final state = 1.obs;

  final data = {}.obs;

  @override
  void initState() {
    super.initState();

    if (id != null) {
      Future.delayed(Duration.zero, () {
        UserController().getAgentDetails(
            id: id,
            success: (res) {
              data(res["list"]);
              username.text = data["username"];
              cnname.text = data["cnname"];
              state(data["status"]);
              Future.delayed(const Duration(milliseconds: 300), () {
                setState(() {});
              });
            });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: id == null ? "新增代理" : "编辑代理",
        body: Column(
          children: [
            id == null
                ? KeyInputView(
                    title: "用户名",
                    controller: username,
                    hint: "请输入用户名",
                    isLeft: false,
                    showBorder: true,
                  )
                : KeyValueView(
                    title: "用户名",
                    valueLeft: false,
                    showBorder: true,
                    value: username.text,
                  ),
            KeyInputView(
              title: "昵称",
              controller: cnname,
              hint: "请输入昵称",
              isLeft: false,
              showBorder: true,
            ),
            KeyInputView(
              title: "密码",
              controller: password,
              hint: "请输入密码",
              isLeft: false,
              showBorder: true,
            ),
            KeyInputView(
              title: "确认密码",
              controller: confirm,
              hint: "请确认密码",
              isLeft: false,
              showBorder: true,
            ),
            if (id != null)
              KeyValueView(
                title: "状态",
                valueLeft: false,
                showIcon: true,
                icon: Obx(() {
                  return Row(
                    children: [
                      Row(
                        children: [
                          state.value == 0
                              ? const Icon(
                                  Icons.radio_button_unchecked,
                                  size: 20,
                                )
                              : Icon(
                                  Icons.check_circle,
                                  size: 20,
                                  color: DSColors.primaryColor,
                                ),
                          12.h,
                          "正常".t.s(16).c(DSColors.title),
                        ],
                      ).onTap(() {
                        state(1);
                      }),
                      12.h,
                      Row(
                        children: [
                          state.value == 1
                              ? const Icon(
                                  Icons.radio_button_unchecked,
                                  size: 20,
                                )
                              : Icon(
                                  Icons.check_circle,
                                  size: 20,
                                  color: DSColors.primaryColor,
                                ),
                          12.h,
                          "禁用".t.s(16).c(DSColors.title),
                        ],
                      ).onTap(() {
                        state(0);
                      }),
                    ],
                  );
                }),
              ),
            24.v,
            "保存"
                .t
                .s(16)
                .c(DSColors.white)
                .center()
                .size(width: 250, height: 40)
                .color(DSColors.primaryColor)
                .borderRadius(radius: 4)
                .onTap(submit)
          ],
        ));
  }

  void submit() {
    if (username.text.isEmpty) {
      MToast.show("请输入用户名");
      return;
    }
    if (cnname.text.isEmpty) {
      MToast.show("请输入昵称");
      return;
    }
    if (id == null) {
      if (password.text.isEmpty) {
        MToast.show("请输入密码");
        return;
      }
      if (password.text != confirm.text) {
        MToast.show("请确认密码");
        return;
      }
    }
    UserController().editUser(
        id: id,
        username: username.text,
        cnname: cnname.text,
        password: password.text,
        state: state.value,
        success: (res) {
          Alert.show(
              title: "提示",
              msg: "提交成功",
              rightAction: () {
                Navigator.pop(context);
                Navigator.pop(context);
              });
        });
  }
}
