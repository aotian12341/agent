import 'package:agent/widget/loader.dart';
import 'package:agent/widget/page_widget.dart';
import 'package:agent/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 我的订单
class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  final loaderController = LoaderController();

  final dataList = [];

  int page = 1;

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        body: Column(
      children: [
        getTime(),
        getContent().expanded(),
      ],
    ));
  }

  Widget getTime() {
    return Row();
  }

  Widget getContent() {
    return Obx(() {
      return Loader(
          controller: loaderController,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              final item = dataList[index];
              return Container();
            },
          ));
    });
  }
}
