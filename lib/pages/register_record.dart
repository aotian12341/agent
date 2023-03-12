import 'package:agent/common/time_helper.dart';
import 'package:agent/controller/user_controller.dart';
import 'package:agent/pages/register_details.dart';
import 'package:agent/widget/header.dart';
import 'package:agent/widget/key_value_view.dart';
import 'package:agent/widget/loader.dart';
import 'package:agent/widget/page_widget.dart';
import 'package:agent/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/colors.dart';

/// 注册报表
class RegisterRecord extends StatefulWidget {
  const RegisterRecord({Key? key}) : super(key: key);

  @override
  State<RegisterRecord> createState() => _RegisterRecordState();
}

class _RegisterRecordState extends State<RegisterRecord> {
  final loaderController = LoaderController();

  final startTime = DateTime.now().format(format: "yyyy-MM-dd").obs;
  final endTime = DateTime.now().format(format: "yyyy-MM-dd").obs;

  final data = {}.obs;

  @override
  void initState() {
    super.initState();

    refresh();
  }

  void refresh() {
    getData(refresh: true);
  }

  void getData({bool refresh = false}) {
    if (refresh) {
      loaderController.loading();
    }

    UserController().getRegisterList(
        startTime: startTime.value,
        endTime: endTime.value,
        success: (res) {
          data(res);
          loaderController.loadFinish();
          data.refresh();
        });
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: "注册报表",
        body: Column(
          children: [
            getHeader(),
            getTotal(),
            getContent().expanded(),
          ],
        ));
  }

  Widget getHeader() {
    /*
    return Obx(() {
      return Column(
        children: [
          Row(
            children: [
              "开始时间:".t.s(16).c(DSColors.title),
              (startTime.isEmpty
                      ? "请选择".t.s(16).c(DSColors.describe)
                      : startTime.toString().t.s(16).c(DSColors.title))
                  .onTap(() {
                showTime(0);
              }).expanded(),
              Icon(
                Icons.keyboard_arrow_right,
                size: 15,
                color: DSColors.describe,
              ),
              "结束时间:".t.s(16).c(DSColors.title),
              (endTime.isEmpty
                      ? "请选择".t.s(16).c(DSColors.describe)
                      : endTime.toString().t.s(16).c(DSColors.title))
                  .onTap(() {
                showTime(1);
              }).expanded(),
              Icon(
                Icons.keyboard_arrow_right,
                size: 15,
                color: DSColors.describe,
              ),
            ],
          )
        ],
      )
          .padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12))
          .borderOnly(bottom: BorderSide(color: DSColors.divider));
    });

     */
    return Header(callBack: (s, e, i) {
      startTime(s);
      endTime(e);
      refresh();
    });
  }

  Widget getContent() {
    return Obx(() {
      final users = data["user"] ?? [];
      List agent = data["agent"] ?? [];
      return Loader(
          controller: loaderController,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        "会员"
                            .t
                            .s(16)
                            .c(DSColors.white)
                            .color(Colors.green)
                            .padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2))
                            .borderRadius(radius: 4),
                      ],
                    ),
                    10.v,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "新增会员".t.s(16).c(DSColors.title),
                        Row(
                          children: [
                            (users.isEmpty ? "0" : users[0]["counts"])
                                .toString()
                                .t
                                .s(16)
                                .c(DSColors.title),
                            8.h,
                            Icon(
                              Icons.keyboard_arrow_right,
                              size: 20,
                              color: DSColors.describe,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
                    .padding(padding: const EdgeInsets.all(12))
                    .border(
                      color: DSColors.primaryColor,
                    )
                    .borderRadius(radius: 8)
                    .margin(
                        margin: const EdgeInsets.only(
                            left: 12, right: 12, bottom: 12))
                    .onTap(() {
                  if (users.isNotEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => RegisterDetails(
                                  parentId: users[0]["parent_id"],
                                  startTime: startTime.value,
                                  endTime: endTime.value,
                                )));
                  }
                }),
                Column(
                  children: [
                    Row(
                      children: [
                        "代理"
                            .t
                            .s(16)
                            .c(DSColors.white)
                            .color(Colors.orange)
                            .padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2))
                            .borderRadius(radius: 4),
                      ],
                    ),
                    10.v,
                    if (agent.isEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "新增会员".t.s(16).c(DSColors.title),
                          Row(
                            children: [
                              "0".toString().t.s(16).c(DSColors.title),
                              8.h,
                              Icon(
                                Icons.keyboard_arrow_right,
                                size: 20,
                                color: DSColors.describe,
                              ),
                            ],
                          ),
                        ],
                      ),
                    Column(
                      children: agent.asMap().keys.map((i) {
                        final item = agent[i];
                        return KeyValueView(
                          title: item["username"],
                          value: "新增会员${item["counts"] ?? 0}",
                          showIcon: true,
                          valueLeft: false,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => RegisterDetails(
                                          parentId: item["parent_id"],
                                          startTime: startTime.value,
                                          endTime: endTime.value,
                                        )));
                          },
                        );
                      }).toList(),
                    ),
                  ],
                )
                    .padding(padding: const EdgeInsets.all(12))
                    .border(
                      color: DSColors.primaryColor,
                    )
                    .borderRadius(radius: 8)
                    .margin(
                        margin: const EdgeInsets.only(
                            left: 12, right: 12, bottom: 12)),
              ],
            ),
          ));
    });
  }

  Widget getTotal() {
    return Obx(() {
      return KeyValueView(
        title: "总邀请人数",
        valueLeft: false,
        value: (data["counts"] ?? "0").toString(),
        showBorder: false,
        height: 60,
      );
    });
  }
}
