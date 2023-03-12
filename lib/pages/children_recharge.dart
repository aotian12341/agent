import 'package:agent/controller/user_controller.dart';
import 'package:agent/widget/loader.dart';
import 'package:agent/widget/page_widget.dart';
import 'package:agent/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/colors.dart';

/// 下级充值记录
class ChildrenRecharge extends StatefulWidget {
  const ChildrenRecharge({Key? key, this.id}) : super(key: key);
  final int? id;
  @override
  State<ChildrenRecharge> createState() => _ChildrenRechargeState();
}

class _ChildrenRechargeState extends State<ChildrenRecharge> {
  final loaderController = LoaderController();

  final data = {}.obs;

  final show1 = true.obs;
  final show2 = true.obs;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      UserController().getChildrenRecharge(
          id: widget.id,
          success: (res) {
            data(res);
            loaderController.loadFinish();
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: "下级充值记录",
        body: Obx(() {
          return Loader(
              controller: loaderController,
              child: SingleChildScrollView(
                child: (data["agent"] == null && data["user"] == null)
                    ? Container()
                    : Column(
                        children: [
                          getAgent(),
                          getUser(),
                        ],
                      ),
              ));
        }));
  }

  Widget getUser() {
    return Obx(() {
      List list = data["user"] ?? [];
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "会员".t.s(16).c(DSColors.title),
              Icon(
                show2.value
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up,
                size: 20,
                color: DSColors.describe,
              )
            ],
          )
              .size(height: 45)
              .borderOnly(bottom: BorderSide(color: DSColors.divider))
              .onTap(() {
            show2(!show2.value);
          }),
          if (show2.value)
            Column(
              // children: [],
              children: list.asMap().keys.map((i) {
                final item = list[i];
                return getItem(item, 0, i);
              }).toList(),
            )
        ],
      )
          .borderOnly(bottom: BorderSide(color: DSColors.divider))
          .padding(
              padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12))
          .margin(margin: const EdgeInsets.only(bottom: 12));
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
            "代理".t.s(16).c(DSColors.title),
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
            children: list.asMap().keys.map((i) {
              final item = list[i];
              return getItem(item, 1, i);
            }).toList(),
          )
      ],
    )
        .borderOnly(bottom: BorderSide(color: DSColors.divider))
        .padding(
            padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12))
        .margin(margin: const EdgeInsets.only(bottom: 12));
  }

  Widget getItem(item, type, index) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            "${item["username"]}(${item["cnname"]})".t.s(16).c(DSColors.title),
            "充值金额:${item["moneys"] ?? 0}".t.s(16).c(DSColors.title),
          ],
        ),
        12.v,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            "充值笔数:${item["counts"] ?? ''}".t.s(16).c(DSColors.title),
            "赚佣:${item["zhan"] ?? 0}".t.s(16).c(DSColors.title),
          ],
        ),
      ],
    )
        .color(index % 2 == 0 ? DSColors.white : DSColors.f2)
        .padding(padding: const EdgeInsets.symmetric(vertical: 10))
        .onTap(() {
      if (type == 1) {
        final temp = item["id"];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ChildrenRecharge(
                      id: item["id"],
                    )));
      }
    });
  }
}
