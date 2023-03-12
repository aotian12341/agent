import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widget/bottom_shell.dart';
import '../widget/m_toast.dart';
import 'http_controller.dart';

class UploaderHelper {
  ///
  void pickerFile({
    required BuildContext context,
    int max = 9,
    String? rootDir,
    UploadListener? listener,
  }) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();

    if (statuses[Permission.camera] == PermissionStatus.granted &&
        statuses[Permission.storage] == PermissionStatus.granted) {
      BottomShell.show(
          items: [
            BottomShellItem(title: "拍摄"),
            BottomShellItem(title: "相册"),
            BottomShellItem(title: "取消"),
          ],
          onChoose: (index) {
            Navigator.pop(context);
            if (index == 0) {
              _pickerCamera(
                context: context,
                listener: listener,
              );
            } else if (index == 1) {
              _pickerGallery(context: context, listener: listener);
            }
          });
    } else {
      MToast.show("请设置权限");
    }
  }

  ///
  void _pickerCamera({
    required BuildContext context,
    UploadListener? listener,
  }) async {
    // AssetEntity? entity;
    // entity = await CameraPicker.pickFromCamera(
    //   context,
    //   enableRecording: true,
    //   onlyEnableRecording: true,
    // );

    final temp = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 5);

    if (temp != null) {
      final path = temp.path;
      upload(path: path, listener: listener);
    }
  }

  ///
  void _pickerGallery(
      {required BuildContext context,
      int? max,
      UploadListener? listener}) async {
    // final List<AssetEntity>? assets = await AssetPicker.pickAssets(
    //   context,
    //   maxAssets: max ?? 1,
    //   requestType: RequestType.all,
    // );

    final temp =
        await ImagePicker().pickMultiImage(imageQuality: 5).then((value) {
      if (value.isNotEmpty) {
        final path = value[0].path;
        upload(path: path, listener: listener);
      }
    });
    // final temp = await ImagePicker()
    //     .pickImage(source: ImageSource.gallery, imageQuality: 5);
  }

  void upload({required String path, UploadListener? listener}) async {
    HttpController().upload(path: path, listener: listener);
  }

  String getRandom(int num) {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    String left = '';
    for (var i = 0; i < num; i++) {
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }

  String getFileType(String path) {
    debugPrint(path);
    List<String> array = path.split('.');
    return array[array.length - 1];
  }
}
