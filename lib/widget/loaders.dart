import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/colors.dart';
import 'loader.dart';

/// 加载状态
enum LoaderState {
  /// 加载中
  loading,

  /// 加载完成
  finish,

  /// 加载完成，没有更多
  completed,

  /// 空数据
  noData,

  /// 错误
  error,
}

/// 加载器
class Loaders extends StatefulWidget {
  ///
  const Loaders({
    Key? key,
    required this.controller,
    required this.child,
    this.header,
    this.footer,
    this.onRefresh,
    this.onLoad,
    this.onError,
    this.onNoData,
    this.refreshColor,
    this.preloadHeight = 100,
    this.scrollController,
    this.noDataMsg = "暂无数据",
    this.errorMsg = "加载错误",
  }) : super(key: key);

  /// 滚动组件
  final Widget child;

  /// 刷新回调
  final Future<void> Function()? onRefresh;

  /// 加载回调
  final Function? onLoad;

  /// 错误回调
  final VoidCallback? onError;

  /// 空数据回调
  final VoidCallback? onNoData;

  /// 空数据文案
  final String noDataMsg;

  /// 加载错误文案
  final String errorMsg;

  /// 头
  final List<Widget>? header;

  /// 脚
  final List<Widget>? footer;

  /// 加载颜色
  final Color? refreshColor;

  /// 预加载高度
  final double preloadHeight;

  /// 控制器
  final LoaderController controller;

  final ScrollController? scrollController;

  @override
  _LoadersState createState() => _LoadersState();
}

class _LoadersState extends State<Loaders> {
  late LoaderController controller;

  @override
  void initState() {
    super.initState();

    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        List<Widget> slivers = [];
        // final content = Container();

        Widget content = Obx(() {
          if (controller.state.value == LoaderState.loading.index) {
            return getLoadingView(constraints);
          } else if (controller.state.value == LoaderState.error.index) {
            return getErrorView(constraints);
          } else if (controller.state.value == LoaderState.noData.index) {
            return getNoDataView(constraints);
          } else if (controller.state.value == LoaderState.finish.index ||
              controller.state.value == LoaderState.completed.index) {
            slivers = _buildSliversByChild();
            return widget.child is! NestedScrollView
                ? _buildListBodyByChild(slivers, null, null)
                : widget.child;
          } else {
            return Container();
          }
        });
        return NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: _handleGlowNotification,
            child: widget.onRefresh == null
                ? content
                : RefreshIndicator(
                    color: widget.refreshColor ?? DSColors.primaryColor,
                    notificationPredicate: (notification) {
                      return true;
                    },
                    onRefresh: _refresh,
                    child: content,
                  ),
          ),
        );
      },
    );
  }

  List<Widget> _buildSliversByChild() {
    Widget? child = widget.child;
    List<Widget> slivers = [];
    if (child is ScrollView) {
      if (child is BoxScrollView) {
        // ignore: invalid_use_of_protected_member
        Widget sliver = child.buildChildLayout(context);
        if (child.padding != null) {
          slivers = [SliverPadding(sliver: sliver, padding: child.padding!)];
        } else {
          slivers = [sliver];
        }
      } else {
        // ignore: invalid_use_of_protected_member
        slivers = List.from(child.buildSlivers(context), growable: true);
      }
    } else if (child is SingleChildScrollView) {
      if (child.child != null) {
        slivers = [
          SliverPadding(
            sliver: SliverList(
              delegate: SliverChildListDelegate([child.child!]),
            ),
            padding: child.padding ?? EdgeInsets.zero,
          ),
        ];
      }
    } else if (child is! Scrollable && child is! NestedScrollView) {
      slivers = [
        SliverToBoxAdapter(
          child: child,
        )
      ];
    }
    if (widget.header != null) {
      slivers.insert(
          0,
          SliverToBoxAdapter(
            child: Column(
              children: widget.header!,
            ),
          ));
    }
    if (widget.footer != null) {
      slivers.add(SliverToBoxAdapter(
        child: Column(
          children: widget.footer!,
        ),
      ));
    }
    if (widget.onLoad != null) {
      slivers.add(SliverToBoxAdapter(
        child: getLoadFooter(),
      ));
    }
    return slivers;
  }

  // 通过child构建列表组件
  Widget _buildListBodyByChild(
      List<Widget> slivers, Widget? header, Widget? footer) {
    Widget child = widget.child;
    if (child is ScrollView) {
      return CustomScrollView(
        controller: widget.scrollController,
        cacheExtent: child.cacheExtent,
        key: child.key,
        scrollDirection: child.scrollDirection,
        semanticChildCount: child.semanticChildCount,
        slivers: slivers,
        dragStartBehavior: child.dragStartBehavior,
        reverse: child.reverse,
      );
    } else if (child is SingleChildScrollView) {
      return CustomScrollView(
        controller: widget.scrollController,
        scrollDirection: child.scrollDirection,
        slivers: slivers,
        dragStartBehavior: child.dragStartBehavior,
        reverse: child.reverse,
      );
    } else if (child is Scrollable) {
      return Scrollable(
        controller: widget.scrollController,
        axisDirection: child.axisDirection,
        semanticChildCount: child.semanticChildCount,
        dragStartBehavior: child.dragStartBehavior,
        viewportBuilder: (context, position) {
          Viewport viewport =
              child.viewportBuilder(context, position) as Viewport;
          return viewport;
        },
      );
    } else {
      return CustomScrollView(
        controller: widget.scrollController,
        slivers: slivers,
      );
    }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    // ScrollNotification scroll = notification as ScrollNotification;
    // // 当前滑动距离
    // double currentExtent = scroll.metrics.pixels;
    // double maxExtent = scroll.metrics.maxScrollExtent;
    // if (maxExtent - currentExtent > widget.startLoadMoreOffset) {
    //   // 开始加载更多
    //
    // }
    // if (notification.metrics.extentAfter -
    //         notification.metrics.maxScrollExtent >=
    //     50) {
    //   if (widget.onLoad != null &&
    //       controller.state.value == LoaderState.finish.index &&
    //       !controller.isLoading.value) {
    //     controller.isLoading(true);
    //     widget.onLoad!();
    //   }
    // }
    //
    // return false;

    if (notification.metrics.pixels >=
        (notification.metrics.maxScrollExtent - 100)) {
      if (widget.onLoad != null &&
          controller.state.value == LoaderState.finish.index &&
          !controller.isLoading.value) {
        controller.isLoading(true);
        widget.onLoad!();
      }
    }
    return false;
  }

  bool _handleGlowNotification(OverscrollIndicatorNotification notification) {
    return false;
  }

  Future<void> _refresh() async {
    controller.loadEnd.value = false;
    controller.loading();
    if (widget.onRefresh != null) {
      await widget.onRefresh!();
    }
  }

  /// 加载组件
  Widget getLoadingView(BoxConstraints constraints) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight + 1,
            child: Center(
              child: Image.asset(
                "assets/images/icon_loading.jpeg",
                width: 100,
              ),
            ),
          ),
        )
      ],
    );
  }

  /// 空数据组件
  Widget getNoDataView(BoxConstraints constraints) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              if (widget.onNoData != null) {
                widget.onError!();
              }
            },
            child: SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight + 1,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   "assets/images/icon_no_data.png",
                    //   width: 200,
                    // ),
                    // const SizedBox(height: 20),
                    Text(
                      "暂无数据",
                      style: TextStyle(color: DSColors.title),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  /// 错误组件
  Widget getErrorView(BoxConstraints constraints) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              if (widget.onError != null) {
                widget.onError!();
              }
            },
            child: SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight + 1,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   "assets/images/icon_error.png",
                    //   width: 200,
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    Text(
                      controller.errorMsg.value.isEmpty
                          ? widget.errorMsg
                          : controller.errorMsg.value,
                      style: TextStyle(color: DSColors.title),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  /// 内容
  List<Widget> getContent() {
    Widget? child = widget.child;

    List<Widget> slivers = [];
    if (child is ScrollView) {
      if (child is BoxScrollView) {
        // ignore: invalid_use_of_protected_member
        Widget sliver = child.buildChildLayout(context);
        if (child is ListView) {
          sliver = SliverToBoxAdapter(
            child: child,
          );
        }
        if (child.padding != null) {
          slivers = [SliverPadding(sliver: sliver, padding: child.padding!)];
        } else {
          slivers = [sliver];
        }
      } else {
        // ignore: invalid_use_of_protected_member
        slivers = List.from(child.buildSlivers(context), growable: true);
      }
    } else {
      slivers = [
        SliverToBoxAdapter(
          child: child,
        )
      ];
    }

    if (widget.header != null) {
      slivers.insert(
          0,
          SliverToBoxAdapter(
            child: Column(
              children: widget.header!,
            ),
          ));
    }
    if (widget.footer != null) {
      slivers.add(SliverToBoxAdapter(
        child: Column(
          children: widget.footer!,
        ),
      ));
    }
    if (widget.onLoad != null) {
      slivers.add(SliverToBoxAdapter(
        child: getLoadFooter(),
      ));
    }

    return slivers;
  }

  Widget getLoadFooter() {
    return SizedBox(
      height: 50,
      child: Center(
        child: Obx(() {
          return Text(
            controller.loadEnd.value ? "暂无更多内容" : "正在加载...",
            style: TextStyle(color: DSColors.describe, fontSize: 14),
          );
        }),
      ),
    );
  }
}
