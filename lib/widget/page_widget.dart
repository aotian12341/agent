import 'dart:ui';

import 'package:flutter/material.dart';
import '../common/colors.dart';
import '../main.dart';

/// 页面组件
class PageWidget extends StatefulWidget {
  ///
  const PageWidget({
    Key? key,
    required this.body,
    this.appBar,
    this.elevation = 0,
    this.showLeading = true,
    this.showAppBar = true,
    this.isCustom = false,
    this.hasTouch = true,
    this.title,
    this.leadingWidth,
    this.titleSpacing,
    this.titleStyle,
    this.titleLabel,
    this.leading,
    this.leadingColor,
    this.action,
    this.brightness,
    this.backgroundColor,
    this.appBarColor,
    this.drawer,
    this.resizeToAvoidBottomInset,
    this.isTouchHideInput,
    this.onWillPop,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonAnimator,
    this.floatingActionButtonLocation,
    this.onStart,
    this.onResume,
    this.onDestroy,
    this.onPause,
    this.loginBack,
  }) : super(key: key);

  /// 标题栏下阴影线粗细
  final double elevation;

  /// 是否显示leading
  final bool showLeading;

  /// leading宽
  final double? leadingWidth;

  /// 标题和leading间距
  final double? titleSpacing;

  /// 自定义Appbar
  final AppBar? appBar;

  /// 是否显示标题栏
  final bool? showAppBar;

  /// 页面组件
  final Widget body;

  /// 标题
  final String? titleLabel;

  /// 标题组件
  final Widget? title;

  /// 标题样式
  final TextStyle? titleStyle;

  /// 左按钮
  final Widget? leading;

  /// 左图标颜色
  final Color? leadingColor;

  /// 右侧操作按钮
  final List<Widget>? action;

  /// 状态栏文字颜色 light,dark;
  final Brightness? brightness;

  /// 页面背景颜色
  final Color? backgroundColor;

  /// 标题栏颜色
  final Color? appBarColor;

  /// 侧滑
  final Drawer? drawer;

  /// 软键盘弹出时是否从新计算页面大小
  final bool? resizeToAvoidBottomInset;

  /// 返回触发
  final Function? onWillPop;

  /// 导航栏
  final Widget? bottomNavigationBar;

  /// 浮动按钮
  final Widget? floatingActionButton;

  /// 是否触碰隐藏软键盘
  final bool? isTouchHideInput;

  /// 浮动按钮位置
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// 按钮动画
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  /// 是否渐变头
  final bool isCustom;

  /// 是否有触摸事件
  final bool hasTouch;

  ///
  final Function()? onStart;

  ///
  final Function()? onResume;

  ///
  final Function()? onDestroy;

  ///
  final Function()? onPause;

  /// 登录回调
  final Function()? loginBack;

  @override
  _PageWidgetState createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget> with RouteAware {
  bool? isLogin;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    App.routerObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    App.routerObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final temp = widget.isCustom
        ? Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.width,
                decoration:
                    BoxDecoration(color: widget.backgroundColor ?? DSColors.f8),
              ),
              Column(
                children: [getCustomAppbar(), Expanded(child: widget.body)],
              )
            ],
          )
        : widget.body;

    return WillPopScope(
      onWillPop: (widget.onWillPop == null) ? null : willPop,
      child: Scaffold(
        backgroundColor: widget.backgroundColor ??
            Theme.of(context)
                .copyWith(
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xff080808)
                            : const Color(0xfff8f8f8))
                .backgroundColor,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        appBar: widget.isCustom ? null : widget.appBar ?? getAppBar(context),
        body: widget.hasTouch
            ? GestureDetector(
                onTap: (widget.isTouchHideInput ?? true)
                    ? () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    : null,
                onVerticalDragUpdate: (widget.isTouchHideInput ?? true)
                    ? (details) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    : null,
                child: temp,
              )
            : temp,
        bottomNavigationBar: widget.bottomNavigationBar,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
      ),
    );
  }

  ///
  AppBar? getAppBar(BuildContext context) {
    if (!(widget.showAppBar ?? true)) {
      return null;
    }

    List<Widget> temp = [];
    temp.addAll(widget.action ?? []);
    temp.add(Container(width: 12));

    return AppBar(
      elevation: widget.elevation,
      automaticallyImplyLeading: widget.showLeading,
      backgroundColor: widget.appBarColor,
      flexibleSpace: widget.appBarColor != null
          ? null
          : Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xff77d0fa), Color(0xff60a7f7)])),
            ),
      brightness: widget.brightness ??
          ((Theme.of(context).brightness != Brightness.dark)
              ? Brightness.light
              : Brightness.dark),
      centerTitle: true,
      titleSpacing: widget.titleSpacing,
      title: widget.title ??
          Text(
            widget.titleLabel ?? "",
            style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 17,
                    color: DSColors.white)
                .merge(widget.titleStyle),
          ),
      leadingWidth: widget.leadingWidth,
      leading: widget.showLeading
          ? widget.leading ??
              InkWell(
                onTap: willPop,
                child: Icon(
                  Icons.chevron_left,
                  size: 30,
                  color: widget.leadingColor ?? DSColors.white,
                ),
              )
          : null,
      iconTheme: IconThemeData(color: widget.leadingColor),
      actions: temp,
    );
  }

  Widget getCustomAppbar() {
    return Container(
      height: MediaQueryData.fromWindow(window).padding.top + kToolbarHeight,
      padding: EdgeInsets.only(
          top: MediaQueryData.fromWindow(window).padding.top,
          left: 12,
          right: 12),
      child: Row(
        children: [
          InkWell(
            onTap: willPop,
            child: Container(
              width: 50,
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.chevron_left,
                size: 20,
                color: widget.leadingColor ?? DSColors.title,
              ),
            ),
          ),
          Expanded(
              child: Text(
            widget.titleLabel ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 17,
                    color: DSColors.title)
                .merge(widget.titleStyle),
          )),
          SizedBox(
            width: 50,
            child: Row(
              children: widget.action ?? [],
            ),
          )
        ],
      ),
    );
  }

  /// 返回事件
  Future<bool> willPop() async {
    if (widget.onWillPop != null) {
      widget.onWillPop!();
    } else {
      Navigator.pop(context);
    }
    return true;
  }

  @override
  void didPush() {
    // push进入当前页面时走这里
    super.didPush();
    if (widget.onStart != null) {
      widget.onStart!();
    }
  }

  @override
  void didPopNext() {
    super.didPopNext();
    // 从其他页面pop回当前页面走这里
    if (widget.onResume != null) {
      widget.onResume!();
    }
  }

  @override
  void didPop() {
    super.didPop();
    if (App.routeList.length > 1) {
      App.routeList.removeLast();
    }

    // pop出当前页面时走这里
    if (widget.onDestroy != null) {
      widget.onDestroy!();
    }
  }

  @override
  void didPushNext() {
    super.didPushNext();
    // 当前页面push到其他页面走这里
    if (widget.onPause != null) {
      widget.onPause!();
    }
  }
}
