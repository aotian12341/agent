import 'package:agent/widget/alert_dialogs.dart';
import 'package:agent/widget/m_toast.dart';
import 'package:agent/widget/page_widget.dart';
import 'package:agent/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../common/colors.dart';
import '../controller/user_controller.dart';
import '../widget/loader.dart';

/// 口令列表
class CodeList extends StatefulWidget {
  const CodeList({Key? key}) : super(key: key);

  @override
  State<CodeList> createState() => _CodeListState();
}

class _CodeListState extends State<CodeList> {
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

    UserController().getCodeList(
        page: page,
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
        titleLabel: "口令列表",
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
                  "新增口令".t.s(12).c(DSColors.white)
                ],
              )
            ],
          ).onTap(() {
            Alert.show(
                title: "提示",
                msg: "是否新增口令?",
                leftAction: () {
                  Navigator.pop(context);
                },
                rightAction: () {
                  Navigator.pop(context);
                  UserController().createCode(success: (res) {
                    MToast.show("操作成功");
                    refresh();
                  });
                });
          })
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
                    Row(
                      children: [
                        (item["code"] ?? "")
                            .toString()
                            .t
                            .s(14)
                            .c(DSColors.title),
                        12.h,
                        if (item["user_id"] == null)
                          "复制"
                              .t
                              .s(14)
                              .c(DSColors.primaryColor)
                              .padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2))
                              .border(color: DSColors.primaryColor)
                              .borderRadius(radius: 4)
                              .onTap(() {
                            Clipboard.setData(
                                    ClipboardData(text: item["code"] ?? ""))
                                .then((value) {
                              MToast.show("复制成功");
                            });
                          })
                      ],
                    ),
                    if (item["user_id"] == null)
                      (item["status"] ?? "")
                          .toString()
                          .t
                          .s(14)
                          .c(DSColors.title),
                  ],
                ),
                8.v,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "创建时间".t.s(14).c(DSColors.title),
                    ((item["created_at"]) ?? "0")
                        .toString()
                        .t
                        .s(14)
                        .c(DSColors.title)
                  ],
                ),
                if (item["user_id"] != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "会员:${item["cnname"] ?? ""}"
                          .toString()
                          .t
                          .s(14)
                          .c(DSColors.title),
                      (item["status"] ?? "")
                          .toString()
                          .t
                          .s(14)
                          .c(DSColors.title),
                    ],
                  ).margin(margin: const EdgeInsets.only(top: 8))
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
