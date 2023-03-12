import 'dart:io';

import 'package:flutter/material.dart';

/// 图片查看
class DSPhotoView extends Dialog {
  ///
  final List<String> images;

  ///
  final int index;

  ///
  PageController? control;

  ///
  DSPhotoView({Key? key, required this.images, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    control ??= PageController(initialPage: index);

    return GestureDetector(
      child: Material(
        //创建透明层
        type: MaterialType.transparency, //透明类型
        child: Center(
          child: SizedBox(
            width: size.width - 20,
            height: size.height - 140,
            child: PageView.builder(
              controller: control,
              itemBuilder: (BuildContext context, int index) {
                String temp = images[index];
                return GestureDetector(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: temp.startsWith("http")
                            ? Image.network(temp, fit: BoxFit.contain)
                            : Image.file(File(temp), fit: BoxFit.contain),
                        onTap: () {},
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                );
              },
              itemCount: images.length,
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
