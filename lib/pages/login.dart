import 'package:agent/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/colors.dart';
import '../common/utils.dart';
import '../common/version_utils.dart';
import '../controller/socket_controller.dart';
import '../controller/user_controller.dart';
import '../routes/Routes.dart';
import '../widget/key_input_view.dart';
import '../widget/m_toast.dart';
import '../widget/page_widget.dart';

/// 登录
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final userName = TextEditingController();
  final password = TextEditingController();

  final rememberPassword = false.obs;

  @override
  void initState() {
    super.initState();

    getCacheData();
    UserController().isShowNotice = false;
  }

  void getCacheData() async {
    final user = await Utils.getCacheValue("wf_userName");
    final psd = await Utils.getCacheValue("wf_password");
    final remember = await Utils.getCacheValue("wf_remember");
    if ((user ?? "").toString().isNotEmpty) {
      userName.text = user;
      password.text = psd;
      rememberPassword(remember as bool);
    }
  }

  void cacheUserName() {
    Utils.cacheValue("wf_userName", userName.text);
  }

  void cacheData() {
    Utils.cacheValue("wf_password", password.text);
    Utils.cacheValue("wf_remember", rememberPassword.value);
  }

  void clearCache() {
    Utils.cacheValue("wf_password", "");
    Utils.cacheValue("wf_remember", false);
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        showAppBar: false,
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 150,
              height: 150,
            ),
            24.h,
            KeyInputView(
              padding: 18,
              title: "用户名",
              hintSize: 18,
              hint: "请输入用户名",
              controller: userName,
              showIcon: true,
              icon: const Icon(
                Icons.clear,
                size: 20,
              ).onTap(() {
                userName.text = "";
              }),
            ).borderRadius(radius: 25).color(DSColors.white.withOpacity(0.8)),
            18.v,
            KeyInputView(
                    isPassword: true,
                    padding: 18,
                    title: "请输入密码",
                    hintSize: 18,
                    hint: "请输入密码",
                    controller: password,
                    showIcon: true,
                    icon: const Icon(
                      Icons.clear,
                      size: 20,
                    ).onTap(() {
                      password.text = "";
                    }))
                .borderRadius(radius: 25)
                .color(DSColors.white.withOpacity(0.8)),
            18.v,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() {
                  return Row(
                    children: [
                      const Icon(
                        Icons.check_box_outline_blank,
                        size: 20,
                      ).or(
                          widget: const Icon(
                            Icons.check_box,
                            size: 20,
                          ),
                          condition: !rememberPassword.value),
                      4.h,
                      "记住密码".t.s(14),
                      8.h,
                    ],
                  ).onTap(() {
                    rememberPassword(!rememberPassword.value);
                  });
                }),
              ],
            ),
            20.v,
            "登录"
                .t
                .s(16)
                .c(DSColors.primaryColor)
                .center()
                .size(width: 250, height: 40)
                .border(color: DSColors.primaryColor)
                .borderRadius(radius: 20)
                .onTap(() {
              if (canClick) {
                login();
              }
            })
          ],
        ).padding(padding: const EdgeInsets.symmetric(horizontal: 20)));
  }

  bool showLoading = false;
  void login() {
    if (userName.text.isEmpty) {
      MToast.show("请输入用户名");
      return;
    }
    if (password.text.isEmpty) {
      MToast.show("请输入密码");
      return;
    }
    canClick = false;
    final temp = context;
    // haha = Future.delayed(const Duration(milliseconds: 1000), () {
    //   if (!showLoading && haha != null) {
    //     showLoading = true;
    //     showDialog(
    //         context: temp,
    //         builder: (_) {
    //           return Loading();
    //         });
    //   }
    // });
    UserController().login(
        userName: userName.text,
        password: password.text,
        success: (value) {
          loginBack(value);
        },
        fail: (error) {
          MToast.show(error);
          haha = null;
          canClick = true;
          // if (showLoading) {
          //   Navigator.pop(context);
          // }
        });
  }

  Future? haha;
  bool canClick = true;

  void loginBack(value) {
    haha = null;
    cacheUserName();
    if (rememberPassword.value) {
      cacheData();
    } else {
      clearCache();
    }
    UserController().isLogin = false;

    if (UserController().user.isAgent == 1) {
      SocketController().connect();
    }
    Get.offAllNamed(Routes.home);
  }

  void click(String tag) {
    // if (tag == "house") {
    // } else if (tag == "wx") {
    // } else if (tag == "register") {
    //   Get.toNamed(Routes.register);
    // }
  }
}
