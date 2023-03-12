import 'package:agent/widget/key_input_view.dart';
import 'package:agent/widget/key_value_view.dart';
import 'package:agent/widget/loader.dart';
import 'package:agent/widget/m_toast.dart';
import 'package:agent/widget/page_widget.dart';
import 'package:agent/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/colors.dart';
import '../controller/user_controller.dart';
import '../routes/Routes.dart';
import '../widget/alert_dialogs.dart';

class UserManager extends StatefulWidget {
  const UserManager({Key? key, this.id}) : super(key: key);

  final int? id;

  @override
  State<UserManager> createState() => _UserManagerState();
}

class _UserManagerState extends State<UserManager> {
  final username = TextEditingController();

  final loaderController = LoaderController();

  final dataList = [].obs;

  int page = 1;

  final money = TextEditingController();

  final back = TextEditingController();

  void getData({bool isRefresh = false}) {
    if (isRefresh) {
      page = 1;
      loaderController.loading();
      dataList.clear();
    } else {
      page += 1;
    }

    UserController().getUserList(
        page: page,
        pid: widget.id,
        username: username.text,
        success: (res) {
          dataList.addAll(res["list"]["data"] ?? []);
          loaderController.loadFinish(
              data: dataList, noMore: res["list"]["total"] <= dataList.length);
        });
  }

  Future<void> refresh() async {
    getData(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: "会员列表",
        action: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 20,
                    color: DSColors.white,
                  ),
                  4.h,
                  "新增代理".t.s(12).c(DSColors.white)
                ],
              ).onTap(() {
                Get.toNamed(Routes.userEdit);
              })
            ],
          ).onTap(() {})
        ],
        onStart: refresh,
        body: Column(
          children: [
            getHeader(),
            getContent().expanded(),
          ],
        ));
  }

  Widget getHeader() {
    return Row(
      children: [
        TextField(
          controller: username,
          decoration: const InputDecoration(
              hintText: "请输入用户名",
              border: OutlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(vertical: 0)),
        )
            .color(DSColors.f8)
            .padding(padding: const EdgeInsets.symmetric(horizontal: 24))
            .border(color: DSColors.describe)
            .borderRadius(radius: 20)
            .expanded(),
        24.h,
        "查询"
            .t
            .s(14)
            .c(DSColors.white)
            .center()
            .size(width: 50, height: 30)
            .color(DSColors.primaryColor)
            .borderRadius(radius: 4)
            .onTap(() {
          refresh();
        })
      ],
    )
        .size(height: 45)
        .padding(padding: const EdgeInsets.symmetric(horizontal: 12))
        .margin(margin: const EdgeInsets.symmetric(vertical: 12));
  }

  Widget getContent() {
    return Obx(() => Loader(
        onRefresh: refresh,
        onLoad: getData,
        controller: loaderController,
        child: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (BuildContext context, int index) {
            final item = dataList[index];
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        "${(item["username"] ?? "")}(${item["cnname"] ?? ""})"
                            .toString()
                            .t
                            .s(14)
                            .c(DSColors.title),
                        item["level_name"]
                            .toString()
                            .t
                            .s(14)
                            .c(DSColors.white)
                            .color(item["is_agent"] == 1
                                ? Colors.orange
                                : DSColors.primaryColor)
                            .padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2))
                            .borderRadius(radius: 4),
                      ],
                    ),
                    Row(
                      children: [
                        (item["status"] == 0 ? "正常" : "禁用")
                            .t
                            .s(14)
                            .c(DSColors.white)
                            .color(item["status"] == 0
                                ? Colors.orange
                                : Colors.green)
                            .padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2))
                            .borderRadius(radius: 4)
                            .margin(margin: const EdgeInsets.only(right: 8)),
                        (item["is_agent"] == 1
                                ? "查看下级"
                                    .t
                                    .s(14)
                                    .c(Colors.orange)
                                    .size(width: 60)
                                : 60.h)
                            .onTap(() {
                          if (item["is_agent"] == 1) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => UserManager(
                                          id: item["id"],
                                        )));
                          }
                        }),
                      ],
                    ),
                  ],
                ),
                8.v,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "余额:${item["money"] ?? "0"}".t.s(14).c(DSColors.title),
                    Row(
                      children: [
                        "本级返点:${item["parent_zhan"]}".t.s(14).c(DSColors.title),
                        "下级返点:${item["zhan"]}".t.s(14).c(DSColors.title),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "注册时间".t.s(14).c(DSColors.title),
                    (item["created_at"] ?? "")
                        .toString()
                        .t
                        .s(14)
                        .c(DSColors.title),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "会员时间".t.s(14).c(DSColors.title),
                    (item["open_time"] ?? "")
                        .toString()
                        .t
                        .s(14)
                        .c(DSColors.title),
                  ],
                ),
                if (item["is_agent"] == 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          "编辑会员"
                              .t
                              .c(DSColors.primaryColor)
                              .padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2))
                              .borderRadius(radius: 4)
                              .border(color: DSColors.primaryColor)
                              .onTap(() {
                            Get.toNamed(Routes.userEdit,
                                arguments: {"id": item["id"]})?.then((value) {
                              refresh();
                            });
                          }),
                          12.h,
                          "编辑返点"
                              .t
                              .c(DSColors.white)
                              .padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2))
                              .color(DSColors.primaryColor)
                              .borderRadius(radius: 4)
                              .onTap(() {
                            showBackDialog(item);
                          })
                        ],
                      ),
                      "-额度"
                          .t
                          .c(DSColors.white)
                          .padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2))
                          .color(Colors.green)
                          .borderRadius(radius: 4)
                          .onTap(() {
                        showMoneyDialog(item);
                      }),
                    ],
                  )
              ],
            )
                .padding(padding: const EdgeInsets.symmetric(vertical: 12))
                .borderOnly(bottom: BorderSide(color: DSColors.divider))
                .margin(
                    margin:
                        const EdgeInsets.only(left: 12, right: 12, bottom: 12));
          },
        )));
  }

  void showMoneyDialog(item) {
    money.text = (item["money"] ?? "").toString();
    Alert.show(
        title: "修改额度",
        view: Column(
          children: [
            KeyValueView(
              title: "当前额度",
              value: (item["money"] ?? "0").toString(),
              valueLeft: false,
            ),
            KeyInputView(
              title: "变更额度",
              controller: money,
              isLeft: false,
              hint: "请输入变更额度",
            )
          ],
        ),
        leftAction: () {
          Navigator.pop(context);
        },
        rightAction: () {
          submitMoney(item);
        });
  }

  void showBackDialog(item) {
    back.text = item["zhan"].toString();
    Alert.show(
        title: "修改返点",
        view: Column(
          children: [
            KeyValueView(
              title: "本级返点",
              value: (item["parent_zhan"] ?? "0").toString(),
              valueLeft: false,
            ),
            KeyInputView(
              title: "下级返点",
              controller: back,
              isLeft: false,
              hint: "请输入下级返点",
            )
          ],
        ),
        leftAction: () {
          Navigator.pop(context);
        },
        rightAction: () {
          submitBack(item);
        });
  }

  void submitBack(item) {
    if (back.text.isEmpty) {
      MToast.show("请输入下级返点");
      return;
    }

    Navigator.pop(context);
    UserController().setZhan(
        id: item["id"],
        zhan: back.text,
        success: (res) {
          refresh();
        });
  }

  void submitMoney(item) {
    if (money.text.isEmpty) {
      MToast.show("请输入正确的额度");
      return;
    }

    Navigator.pop(context);
    UserController().setMoney(
        id: item["id"],
        money: (double.parse(money.text) * -1).toString(),
        success: (res) {
          refresh();
        });
  }
}
