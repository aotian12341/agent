import 'package:agent/controller/user_controller.dart';
import 'package:agent/widget/key_input_view.dart';
import 'package:agent/widget/m_toast.dart';
import 'package:agent/widget/page_widget.dart';
import 'package:agent/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/colors.dart';
import '../routes/Routes.dart';
import '../widget/alert_dialogs.dart';

/// 修改密码
class EditPassword extends StatefulWidget {
  const EditPassword({Key? key}) : super(key: key);

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final old = TextEditingController();
  final nPass = TextEditingController();
  final cPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: "修改密码",
        body: Column(
          children: [
            KeyInputView(
              title: "旧密码",
              hint: "请输入旧密码",
              isLeft: false,
              controller: old,
              height: 55,
            ),
            KeyInputView(
              title: "新密码",
              hint: "请输入新密码",
              isLeft: false,
              controller: nPass,
              height: 55,
            ),
            KeyInputView(
              title: "旧密码",
              hint: "请确认密码",
              isLeft: false,
              controller: cPass,
              height: 55,
            ),
            12.v,
            "保存"
                .t
                .s(16)
                .c(DSColors.white)
                .center()
                .size(width: 300, height: 40)
                .color(DSColors.primaryColor)
                .borderRadius(radius: 8)
                .onTap(() {
              if (old.text.isEmpty) {
                MToast.show("请输入旧密码");
                return;
              }
              if (nPass.text.isEmpty) {
                MToast.show("请输入新密码");
                return;
              }
              if (old.text.isEmpty) {
                MToast.show("请确认密码");
                return;
              }

              UserController().editPassword(
                  old: old.text,
                  newStr: nPass.text,
                  success: (res) {
                    Alert.show(
                        title: "提示",
                        msg: "操作成功,请重新登录",
                        rightAction: () {
                          UserController().loginOut();

                          Get.offAllNamed(Routes.login);
                        });
                  });
            })
          ],
        ));
  }
}
