import 'package:agent/widget/loader.dart';
import 'package:agent/widget/page_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/video_controller.dart';
import 'video.dart';

///
class VideoList extends StatefulWidget {
  const VideoList({Key? key}) : super(key: key);

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  final loaderController = LoaderController();

  final videoList = [].obs;

  final classId = Get.arguments?["classId"] ?? 0;

  final name = Get.arguments?["typeName"] ?? "";

  int page = 1;

  @override
  void initState() {
    super.initState();

    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: name,
        body: Obx(() {
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
        }));
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
        classId: classId,
        success: (res) {
          if (page == 1) {
            videoList.clear();
          }

          videoList.addAll(res["list"]["data"] ?? []);

          loaderController.loadFinish(
              data: videoList,
              noMore: videoList.length >= (res["list"]["total"] ?? 0));
        });
  }
}
