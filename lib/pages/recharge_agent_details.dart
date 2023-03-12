import 'package:agent/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/colors.dart';
import '../controller/user_controller.dart';
import '../widget/key_value_view.dart';
import '../widget/loader.dart';
import '../widget/page_widget.dart';

/// 代理报表
class RechargeAgentDetails extends StatefulWidget {
  const RechargeAgentDetails(
      {Key? key, this.parentId, this.startTime, this.endTime})
      : super(key: key);

  final int? parentId;
  final String? startTime;
  final String? endTime;

  @override
  State<RechargeAgentDetails> createState() => _RechargeAgentDetailsState();
}

class _RechargeAgentDetailsState extends State<RechargeAgentDetails> {
  final loaderController = LoaderController();

  final data = {}.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    refresh();
  }

  Future<void> refresh() async {
    getData(refresh: true);
  }

  void getData({bool refresh = false}) {
    if (refresh) {
      loaderController.loading();
    }

    UserController().getAgentRecord(
        parentId: widget.parentId,
        startTime: widget.startTime,
        endTime: widget.endTime,
        success: (res) {
          data(res);
          data.refresh();
          loaderController.loadFinish();
        });
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: "代理分红报表",
        body: Column(
          children: [
            getHeader(),
            12.v,
            getContent().expanded(),
          ],
        ));
  }

  Widget getHeader() {
    return Obx(() {
      Map top = data["top"] ?? {};

      final temp = [];
      top.forEach((key, value) {
        temp.add("$key:$value");
      });
      if (temp.isEmpty) {
        return Container();
      }
      return Column(
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
          KeyValueView(
            title: temp[0],
            value: temp.length > 1 ? temp[1] : "",
            valueLeft: false,
          )
        ],
      );
    });
  }

  Widget getContent() {
    return Obx(() {
      final dataList = data["list"] ?? [];

      return Loader(
          onRefresh: refresh,
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
                      "会员编号:${item["user_id"]}".t.s(16).c(DSColors.title),
                      "订单编号:${item["order_id"]}".t.s(16).c(DSColors.title),
                    ],
                  ),
                  10.v,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          "${item["username"] ?? ""}(${item["cnname"] ?? ""})"
                              .t
                              .s(16)
                              .c(DSColors.title),
                          8.h,
                          ((item["is_agent"] ?? 0) == 0 ? '会员' : '代理')
                              .t
                              .s(16)
                              .c(DSColors.white)
                              .color((item["is_agent"] ?? 0) == 0
                                  ? Colors.green
                                  : Colors.orange)
                              .padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2))
                              .borderRadius(radius: 4),
                        ],
                      ),
                      "返点:${item["zhan"] ?? 0}".t.s(16).c(DSColors.title),
                    ],
                  ),
                  10.v,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "充值金额:${item["money"] ?? 0}".t.s(16).c(DSColors.title),
                      "赚佣:${item["zhan_money"] ?? 0}".t.s(16).c(DSColors.title),
                    ],
                  ),
                  10.v,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "充值时间".t.s(16).c(DSColors.title),
                      (item["created_at"] ?? "")
                          .toString()
                          .t
                          .s(16)
                          .c(DSColors.title),
                    ],
                  ),
                ],
              )
                  .padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10))
                  .border(color: DSColors.primaryColor)
                  .borderRadius(radius: 8)
                  .margin(
                      margin: const EdgeInsets.only(
                          left: 12, right: 12, bottom: 12))
                  .onTap(() {
                if (item["is_agent"] == 1 &&
                    item["down_id"] != item["user_id"]) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => RechargeAgentDetails(
                                parentId: item["down_id"],
                                startTime: widget.startTime,
                                endTime: widget.endTime,
                              )));
                }
              });
            },
          ));
    });
  }
}
