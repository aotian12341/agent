import 'package:agent/common/time_helper.dart';
import 'package:agent/widget/key_value_view.dart';
import 'package:agent/widget/page_widget.dart';
import 'package:agent/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/colors.dart';
import '../controller/user_controller.dart';
import '../widget/loader.dart';

/// 注册详情
class RegisterDetails extends StatefulWidget {
  const RegisterDetails({Key? key, this.parentId, this.startTime, this.endTime})
      : super(key: key);

  final int? parentId;
  final String? startTime;
  final String? endTime;

  @override
  State<RegisterDetails> createState() => _RegisterDetailsState();
}

class _RegisterDetailsState extends State<RegisterDetails> {
  final loaderController = LoaderController();

  final data = {}.obs;
  final show1 = true.obs;
  final show2 = true.obs;

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

    UserController().getRegisterDetails(
        parentId: widget.parentId,
        startTime: widget.startTime,
        endTime: widget.endTime,
        success: (res) {
          if ((res["user"] ?? []).isEmpty && (res["agent"] ?? []).isEmpty) {
            loaderController.loadNullData();
          } else {
            data(res);
            data.refresh();
            loaderController.loadFinish();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: "注册信息详情",
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                "开始时间:${widget.startTime}".t.s(16).c(DSColors.title),
                "结束时间:${widget.endTime}".t.s(16).c(DSColors.title),
              ],
            ).padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
            Obx(() {
              return Loader(
                  controller: loaderController,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        getUser(),
                        getAgent(),
                      ],
                    ),
                  ));
            }).expanded(),
          ],
        ));
  }

  Widget getUser() {
    return Obx(() {
      List list = data["user"] ?? [];
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Icon(
                !show2.value
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up,
                size: 20,
                color: DSColors.describe,
              )
            ],
          ).onTap(() {
            show2(!show2.value);
          }),
          if (show2.value)
            Column(
              children: list.isEmpty
                  ? [
                      "暂无数据"
                          .t
                          .s(16)
                          .c(DSColors.subTitle)
                          .center()
                          .size(height: 45),
                    ]
                  : list.asMap().keys.map((i) {
                      final item = list[i];
                      return getItem(item);
                    }).toList(),
            )
        ],
      )
          .padding(padding: const EdgeInsets.all(12))
          .border(
            color: DSColors.primaryColor,
          )
          .borderRadius(radius: 8)
          .margin(
              margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12));
    });
  }

  Widget getAgent() {
    List list = data["agent"] ?? [];
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            "代理"
                .t
                .s(16)
                .c(DSColors.white)
                .color(Colors.orange)
                .padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2))
                .borderRadius(radius: 4),
            Icon(
              show1.value ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
              size: 20,
              color: DSColors.describe,
            )
          ],
        )
            .size(height: 45)
            .borderOnly(bottom: BorderSide(color: DSColors.divider))
            .onTap(() {
          show1(!show1.value);
        }),
        if (show1.value)
          Column(
            children: list.isEmpty
                ? [
                    "暂无数据"
                        .t
                        .s(16)
                        .c(DSColors.subTitle)
                        .center()
                        .size(height: 45),
                  ]
                : list.asMap().keys.map((i) {
                    final item = list[i];
                    return getItem(item);
                  }).toList(),
          )
      ],
    )
        .padding(padding: const EdgeInsets.all(12))
        .border(
          color: DSColors.primaryColor,
        )
        .borderRadius(radius: 8)
        .margin(margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12));
  }

  Widget getItem(item) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            "用户名:${item["username"] ?? ''}"
                .toString()
                .t
                .s(14)
                .c(DSColors.title),
            "注册时间:${item["created_at"] ?? ""}"
                .toString()
                .t
                .s(14)
                .c(DSColors.title),
          ],
        ),
      ],
    )
        .padding(padding: const EdgeInsets.symmetric(vertical: 12))
        .borderOnly(bottom: BorderSide(color: DSColors.divider))
        .margin(margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12));
  }
}
