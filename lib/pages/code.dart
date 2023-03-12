import 'dart:io';
import 'dart:typed_data';

import 'package:agent/common/colors.dart';
import 'package:agent/constants/app_config.dart';
import 'package:agent/controller/user_controller.dart';
import 'package:agent/widget/page_widget.dart';
import 'package:agent/widget/view_ex.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common/utils.dart';
import '../widget/m_toast.dart';
import 'dart:ui' as ui;

/// 邀请码
class Code extends StatefulWidget {
  const Code({Key? key}) : super(key: key);

  @override
  State<Code> createState() => _CodeState();
}

class _CodeState extends State<Code> {
  final data = {}.obs;

  final globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      getData();
    });
  }

  void getData() {
    UserController().getCode(success: (res) {
      data(res);
      data.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: "分享",
        body: Obx(() {
          if (data["code"] == null) {
            return Container();
          }
          String url = AppConfig.baseUrl.endsWith("/") &&
                  data["path"].toString().startsWith("/")
              ? "${AppConfig.baseUrl.substring(0, AppConfig.baseUrl.length - 1)}${data["path"]}"
              : "${AppConfig.baseUrl}${data["path"]}";
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ["您的分享码为：${data["code"]}".t.s(16).c(DSColors.title)],
              ),
              12.v,
              // Image.network(
              //   url,
              //   width: 150,
              //   height: 150,
              // ),
              RepaintBoundary(
                key: globalKey,
                child: SvgPicture.network(
                  url,
                  width: 150,
                  height: 150,
                ),
              ),
              12.v,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  "分享给您的好友，填写您的邀请码，注册并充值成功，将奖励您三天观看"
                      .t
                      .s(16)
                      .c(DSColors.title)
                      .flexible()
                ],
              ).padding(padding: const EdgeInsets.symmetric(horizontal: 20)),
              24.v,
              "保存二维码"
                  .t
                  .s(16)
                  .c(DSColors.title)
                  .padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 4))
                  .borderRadius(radius: 8)
                  .border(color: DSColors.title)
                  .onTap(() async {
                _save(globalKey);
              })
            ],
          );
        }));
  }

  /// 保存图片
  void _save(globalKey) async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? picBytes = byteData?.buffer?.asUint8List();
    final result = await ImageGallerySaver.saveImage(picBytes!,
        quality: 100, name: "hello");
    print(result);
    if (result['isSuccess']) {
      MToast.show('保存成功');
    } else {
      MToast.show('保存失败');
    }
  }

  void saveImageNetwork(String url, String name) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    if (statuses[Permission.storage] == PermissionStatus.granted) {
      var response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes));

      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name: name);

      if (result != null) {
        MToast.show(result["isSuccess"]
            ? '下载成功，请在相册中查看'
            : '下载失败,${result["errorMessage"]}');
      }
    }
  }

  void saveFile(String url) async {
    var appDocDir = await getTemporaryDirectory();
    String savePath = "${appDocDir.path}/temp.png";

    ///temp.png这个自己命名
    await Dio().download(url, savePath);
    await ImageGallerySaver.saveFile(savePath,
            isReturnPathOfIOS: Platform.isAndroid ? false : true)
        .then((result) {
      MToast.show(result["isSuccess"]
          ? '下载成功，请在相册中查看'
          : '下载失败,${result["errorMessage"]}');
    });
  }
}
