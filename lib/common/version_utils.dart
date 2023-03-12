import 'dart:io';

import 'package:agent/widget/view_ex.dart';
import 'package:better_open_file/better_open_file.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/api_keys.dart';
import '../constants/app_config.dart';
import '../widget/ds_slider.dart';
import '../widget/m_toast.dart';
import 'colors.dart';
import 'http_controller.dart';
import 'utils.dart';

class VersionUtils {
  static PackageInfo? version;

  void checkVersion(Function? success,
      {bool? showLoading, Function? fail}) async {
    version = await PackageInfo.fromPlatform();

    if (Platform.isAndroid) {
      HttpController().get(UserApi.androidVersion,
          query: {"version": version?.version},
          showLoading: true,
          success: success,
          fail: fail);
    }
  }

  void showUpdate(BuildContext context, dynamic value) async {
    if (Platform.isAndroid) {
      if (path == null) {
        final directory = await getExternalStorageDirectory();
        String localPath = directory?.path ?? "";

        path = '$localPath/app-release_${value["Version"]}.apk';
      }
    }
    showDialog<dynamic>(
        context: context,
        builder: (_) {
          return Material(
            type: MaterialType.transparency, //透明类型
            child: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: GestureDetector(
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: GestureDetector(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(8))),
                              child: Image.asset(
                                "assets/images/version_bg.png",
                                fit: BoxFit.cover,
                                width: Utils.isPc(context) ? 500 : null,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 20),
                              decoration: BoxDecoration(
                                color: DSColors.white,
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(8),
                                ),
                              ),
                              child: Obx(() {
                                return showProgress.value
                                    ? getProgressView(value, context)
                                    : getVersionView(value, context);
                              }),
                            ),
                          ],
                        ).size(width: Utils.isPc(context) ? 500 : null),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                onTap: () {},
              ),
            ),
          );
        });
  }

  Widget getVersionView(value, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "发现新版本",
              style: TextStyle(color: DSColors.title, fontSize: 20),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: DSColors.primaryColor)),
              child: Text(
                "v${value["Version"] ?? ""}",
                style: TextStyle(color: DSColors.primaryColor, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Row(
              children: ["立即升级".t.s(18).c(DSColors.white).center().expanded()],
            )
                .size(height: 45)
                .margin(margin: const EdgeInsets.symmetric(horizontal: 20))
                .color(DSColors.primaryColor)
                .borderRadius(radius: 22.5)
                .onTap(() async {
              if (!Platform.isAndroid) {
                final url = value["AppPath"].toString();
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                } else {
                  throw '无法打开浏览器，请稍后再试';
                }
              } else {
                // final file = File(path ?? "");
                // if (await file.exists()) {
                //   status(2);
                // } else {
                status(1);
                upgrade(context, "${AppConfig.baseUrl}${value["path"]}");
                // }
                showProgress(true);
              }
            }).expanded(),
            if (Platform.isAndroid) 24.h,
            if (Platform.isAndroid)
              Row(
                children: [
                  "手动更新".t.s(18).c(DSColors.primaryColor).center().expanded()
                ],
              )
                  .size(height: 45)
                  .margin(margin: const EdgeInsets.symmetric(horizontal: 20))
                  .borderRadius(radius: 22.5)
                  .border(color: DSColors.primaryColor)
                  .onTap(() async {
                final url = value["AppPath"].toString();
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                } else {
                  MToast.show('无法打开浏览器，请稍后再试');
                }
              }).expanded()
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "建议在wifi条件下更新哦",
              style: TextStyle(color: DSColors.describe),
            ),
          ],
        ),
      ],
    );
  }

  Widget getProgressView(value, BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Text(
            status.value == 2 ? "下载完毕" : "正在下载更新包",
            style: TextStyle(color: DSColors.title, fontSize: 20),
          ),
          const SizedBox(height: 30),
          if (status.value != 2)
            Text(
              "${(progress.value * 100).toStringAsFixed(2)}%",
              style: TextStyle(
                  color: error.value.isNotEmpty
                      ? DSColors.describe
                      : DSColors.primaryColor,
                  fontSize: 14),
            ),
          if (status.value != 2)
            Container(
              height: 5,
              margin: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: DSSlider(
                      sliderSize: 0,
                      value: progress.value * 100,
                      activeColor: DSColors.primaryColor,
                      barHeight: 3,
                      disabled: error.value.isEmpty,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          if (status.value != 2)
            Stack(
              alignment: Alignment.topRight,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      error.value.isEmpty
                          ? "${Utils.getFileSize(fileCount.value)}/${Utils.getFileSize(fileSize.value)}"
                          : error.value,
                      style: TextStyle(color: DSColors.describe, fontSize: 12),
                    ),
                  ],
                ),
                if (error.value.isNotEmpty)
                  InkWell(
                    onTap: () {
                      status(1);
                      upgrade(context, "${AppConfig.baseUrl}${value["path"]}");
                    },
                    child: Text(
                      "重试",
                      style:
                          TextStyle(color: DSColors.primaryColor, fontSize: 12),
                    ),
                  )
              ],
            ),
          const SizedBox(height: 32),
          if (status.value == 1 || status.value == 2)
            (status.value == 2 ? "打开" : "取消")
                .t
                .c(DSColors.primaryColor)
                .s(16)
                .center()
                .size(width: 175, height: 35)
                .borderRadius(radius: 4)
                .border(color: DSColors.primaryColor)
                .onTap(() {
              if (status.value == 1) {
                status(3);
                token.cancel();
              } else {
                OpenFile.open(path);
              }
            }),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "建议在wifi条件下更新哦",
                style: TextStyle(color: DSColors.describe),
              ),
            ],
          ),
        ],
      );
    });
  }

  final showProgress = false.obs;
  final fileCount = 0.0.obs;
  final fileSize = 0.obs;
  final error = "".obs;

  final status = 0.obs;

  /// 0等待下载，1正在下载，2下载完毕，3下载取消

  final progress = 0.0.obs;
  String? path;

  late CancelToken token;
  void upgrade(BuildContext context, url) async {
    if (Platform.isIOS) {
      // String url = 'itms-apps://itunes.apple.com/cn/app/id${info.appId}?mt=8';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      fileCount(0);
      progress(0);
      error("");

      token = CancelToken();

      HttpController().download(
        url: url ?? "",
        path: path!,
        token: token,
        listener: DownloadListener(
          onStart: () {
            // showProgress(true);
          },
          onProgress: (total, pro) {
            fileCount(pro * total);
            fileSize(total);
            progress(pro);
          },
          onFinish: () {
            status(2);
            OpenFile.open(path);
          },
          onError: (err) {
            error(status.value == 3 ? "已取消" : "网络异常");
          },
        ),
      );
    }
  }
}
