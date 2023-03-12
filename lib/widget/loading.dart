import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';

/// 加载
class Loading extends Dialog {
  ///
  Loading({Key? key, this.msg}) : super(key: key);

  late BuildContext context;
  final String? msg;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Material(
        //创建透明层
        type: MaterialType.transparency, //透明类型
        child: GestureDetector(
          onTap: () => hide(),
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                // child: Image.asset(
                //   "assets/images/icon_loadings.gif",
                //   width: 100,
                // ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: CircularProgressIndicator(
                        color: DSColors.primaryColor,
                      ),
                    ),
                    Text(
                      msg ?? "",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )),
        ));
  }

  ///
  void hide() {
    Navigator.pop(Get.context ?? context);
  }
}
