import 'package:agent/controller/video_controller.dart';
import 'package:agent/widget/loader.dart';
import 'package:agent/widget/page_widget.dart';
import 'package:agent/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/colors.dart';
import '../routes/Routes.dart';

/// 视频
class Video extends StatefulWidget {
  const Video({Key? key}) : super(key: key);

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  final loaderController = LoaderController();

  final classList = [].obs;

  final videoList = [].obs;

  int page = 1;

  @override
  void initState() {
    super.initState();

    refresh();
  }

  Future<void> refresh() async {
    getData(refresh: true);
  }

  Future<void> getData({bool refresh = false}) async {
    if (refresh) {
      page = 1;
      loaderController.loading();
    } else {
      page += 1;
    }

    VideoController().getHomeData(
        page: page,
        success: (res) {
          classList.clear();
          if (page == 1) {
            videoList.clear();
          }
          classList.addAll(res["table"] ?? []);

          videoList.addAll(res["list"]["data"] ?? []);

          loaderController.loadFinish(
              data: videoList,
              noMore: videoList.length >= (res["list"]["total"] ?? 0));
        });
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "分享好友"
                .t
                .s(14)
                .c(DSColors.white)
                .padding(padding: const EdgeInsets.only(left: 0))
          ],
        ),
        leadingWidth: 80,
        action: [
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     "个人中心".t.s(14).c(DSColors.white),
          //   ],
          // ).onTap(() {})
        ],
        body: Column(
          children: [
            getClassView(),
            12.v,
            getTitle(),
            getContent().expanded(),
          ],
        ));
  }

  Widget getTitle() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xff77d0fa), Color(0xff60a7f7)])),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 5,
            height: 30,
            color: DSColors.white,
          ),
          12.h,
          "最新视频".t.s(16).c(DSColors.white),
        ],
      ),
    );
  }

  Widget getClassView() {
    final cellWidth = MediaQuery.of(context).size.width / 5;
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xff77d0fa), Color(0xff60a7f7)])),
        child: Row(
          children: [
            Wrap(
              spacing: 0,
              runSpacing: 12,
              children: classList.asMap().keys.map((i) {
                final item = classList[i];
                return Text(
                  item["typeName"] ?? "",
                  style: TextStyle(
                      color: DSColors.white,
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis),
                ).center().size(width: cellWidth).onTap(() {
                  Get.toNamed(Routes.videoList, arguments: {
                    "classId": item["id"],
                    "typeName": item["typeName"]
                  });
                });
              }).toList(),
            ).expanded()
          ],
        ),
      );
    });
  }

  Widget getContent() {
    return Obx(() {
      return Loader(
          onRefresh: refresh,
          onLoad: getData,
          controller: loaderController,
          child: GridView.builder(
            itemCount: videoList.length,
            itemBuilder: (BuildContext context, int index) {
              final item = videoList[index];
              return VideoItem(
                item: item,
                index: index,
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 16 / 12),
          ));
    });
  }
}

class VideoItem extends StatelessWidget {
  const VideoItem({Key? key, this.item, required this.index}) : super(key: key);

  final dynamic item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                // "https://img1.baidu.com/it/u=2208383513,1937856084&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=709",
                item["photo"].toString(),
                fit: BoxFit.contain,
              ),
            ).expanded()
          ],
        ),
        10.v,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item["title"] ?? "",
              style: TextStyle(
                  color: DSColors.title,
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis),
            ).flexible()
          ],
        ).expanded()
      ],
    )
        .padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10))
        .borderOnly(
            bottom: BorderSide(color: DSColors.divider),
            right: index % 2 == 1 ? null : BorderSide(color: DSColors.divider))
        .onTap(() {
      // Get.toNamed(Routes.videoDetails, arguments: item);
      Get.toNamed(Routes.videoDetailss, arguments: item);
    });
  }
}
