import 'package:agent/widget/loader.dart';
import 'package:agent/widget/page_widget.dart';
import 'package:agent/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/colors.dart';
import '../controller/user_controller.dart';

/// 邀请列表
class InviteList extends StatefulWidget {
  const InviteList({Key? key}) : super(key: key);

  @override
  State<InviteList> createState() => _InviteListState();
}

class _InviteListState extends State<InviteList> {
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

    UserController().getInviteList(
        page: page,
        success: (res) {
          dataList.addAll(res["list"]["data"] ?? []);
          loaderController.loadFinish(
              data: dataList, noMore: res["list"]["total"] <= dataList.length);
          if (page == 1 && dataList.length < res["list"]["total"]) {
            page += 1;
            UserController().getInviteList(
                page: page,
                success: (res) {
                  dataList.addAll(res["list"]["data"] ?? []);
                  loaderController.loadFinish(
                      data: dataList,
                      noMore: res["list"]["total"] <= dataList.length);
                });
          }
        });
  }

  Future<void> refresh() async {
    getData(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: "邀请列表",
        onStart: refresh,
        body: Column(
          children: [
            getContent().expanded(),
          ],
        ));
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
                .margin(
                    margin:
                        const EdgeInsets.only(left: 12, right: 12, bottom: 12));
          },
        )));
  }
}
