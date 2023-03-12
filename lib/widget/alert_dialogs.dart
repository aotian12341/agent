import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/colors.dart';

/// 弹出窗
class Alert {
  ///
  static void show({
    Widget? view,
    String? title,
    String? leftText,
    String? rightText,
    String? msg,
    Function? leftAction,
    Function? rightAction,
    Function? cancelAction,
    bool? actionHidden,
    bool? canCancel,
  }) {
    showDialog<dynamic>(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialogs(
            view: view,
            title: title,
            message: msg,
            leftText: leftText,
            leftAction: leftAction,
            rightText: rightText,
            rightAction: rightAction,
            actionHidden: actionHidden,
            cancelAction: cancelAction,
            canCancel: canCancel,
          );
        });
  }
}

///
class AlertDialogs extends Dialog {
  /// 展示组件
  final Widget? view;

  /// 左右点击事件
  final Function? leftAction, rightAction, cancelAction;

  /// 左右标题，对话框标题
  final String? leftText, rightText;

  /// 标题
  final String? title;

  /// 是否隐藏操作按钮
  final bool? actionHidden;

  final String? message;

  final double? padding;

  final bool? canCancel;

  final bool? transparent;

  ///
  const AlertDialogs({
    Key? key,
    this.view,
    this.title,
    this.leftText,
    this.rightText,
    this.leftAction,
    this.rightAction,
    this.actionHidden,
    this.message,
    this.padding,
    this.cancelAction,
    this.canCancel,
    this.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      child: Material(
        type: MaterialType.transparency, //透明类型
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            child: Center(
                child: SizedBox(
              width: ((MediaQuery.of(context).size.width >
                          MediaQuery.of(context).size.height)
                      ? 500
                      : size.width) -
                  ((padding ?? 60) * 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Column(
                      children: <Widget>[
                        (title ?? "").isEmpty
                            ? Container()
                            : Container(
                                height: 40,
                                color: Colors.white,
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        title ?? "",
                                        style: TextStyle(
                                            color: DSColors.title,
                                            fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                        Container(
                          constraints: const BoxConstraints(minHeight: 90),
                          color: (transparent ?? false)
                              ? Colors.transparent
                              : Colors.white,
                          padding: EdgeInsets.only(
                              left: (actionHidden ?? false) ? 0 : 20,
                              right: (actionHidden ?? false) ? 0 : 20),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: message != null
                                    ? Center(
                                        child: Text(
                                          message!,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: DSColors.title),
                                        ),
                                      )
                                    : view ?? Container(),
                              )
                            ],
                          ),
                        ),
                        (actionHidden ?? false)
                            ? Container()
                            : Container(
                                height: 50,
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                decoration:
                                    BoxDecoration(color: DSColors.white),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    if (leftAction != null)
                                      Expanded(
                                        child: InkWell(
                                          child: Center(
                                            child: Text(
                                              leftText ?? "取消",
                                              style: TextStyle(
                                                  color: DSColors.title),
                                            ),
                                          ),
                                          onTap: () {
                                            if (leftAction != null) {
                                              leftAction!();
                                            } else {
                                              Navigator.pop(context);
                                            }
                                          },
                                        ),
                                      ),
                                    if (leftAction != null &&
                                        rightAction != null)
                                      const SizedBox(width: 20, height: 50),
                                    if (rightAction != null)
                                      Expanded(
                                        child: InkWell(
                                          child: Center(
                                              child: Text(rightText ?? "确认",
                                                  style: TextStyle(
                                                      color: DSColors.title))),
                                          onTap: () {
                                            if (rightAction != null) {
                                              rightAction!();
                                            } else {
                                              Navigator.pop(context);
                                            }
                                          },
                                        ),
                                      )
                                  ],
                                ),
                              )
                      ],
                    ),
                  ),
                ],
              ),
            )),
            onTap: () {},
          ),
        ),
      ),
      onTap: () {
        if (canCancel ?? true) {
          Navigator.pop(context);
          if (cancelAction != null) {
            cancelAction!();
          }
        }
      },
    );
  }
}
