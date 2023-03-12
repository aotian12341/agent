import 'package:agent/common/colors.dart';
import 'package:agent/widget/loader.dart';
import 'package:agent/widget/page_widget.dart';
import 'package:agent/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/user_controller.dart';

class RechargeList extends StatefulWidget {
  const RechargeList({Key? key}) : super(key: key);

  @override
  State<RechargeList> createState() => _RechargeListState();
}

class _RechargeListState extends State<RechargeList> {
  final loaderController = LoaderController();

  final dataList = [].obs;

  int page = 1;

  void getData({bool isRefresh = false}) {
    if (isRefresh) {
      page = 1;
      loaderController.loading();
      dataList.clear();
    } else {
      page += 1;
    }

    UserController().getRechargeList(success: (res) {
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
        titleLabel: "充值列表",
        onStart: refresh,
        body: Column(
          children: [
            getHeader(),
            getContent().expanded(),
          ],
        ));
  }

  Widget getHeader() {
    return Container();
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
                    (item["type"] ?? "")
                        .toString()
                        .t
                        .s(14)
                        .c(Colors.white)
                        .center()
                        .color(item["type"] == "充值会员"
                            ? Colors.orange
                            : DSColors.primaryColor)
                        .padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4))
                        .borderRadius(radius: 4),
                    (item["date"] ?? "").toString().t.s(14).c(DSColors.title),
                  ],
                ),
                8.v,
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "变更前金额".t.s(14).c(DSColors.title),
                        ((item["before_money"]) ?? "0")
                            .toString()
                            .t
                            .s(14)
                            .c(DSColors.title)
                      ],
                    ).expanded(),
                    Column(
                      children: [
                        "变更金额".t.s(14).c(DSColors.title),
                        ((item["edit_money"]) ?? "0").toString().t.s(14).c(
                            item["edit_money"] > 0 ? Colors.green : Colors.red)
                      ],
                    ).expanded(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        "余额".t.s(14).c(DSColors.title),
                        ((item["money"]) ?? "0")
                            .toString()
                            .t
                            .s(14)
                            .c(DSColors.title)
                      ],
                    ).expanded(),
                  ],
                ),
                8.v,
                Row(
                  children: [
                    (item["content"] ?? "")
                        .toString()
                        .t
                        .s(14)
                        .c(DSColors.subTitle)
                        .expanded()
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
}
