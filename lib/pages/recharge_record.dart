import 'package:agent/common/time_helper.dart';
import 'package:agent/pages/recharge_agent_details.dart';
import 'package:agent/pages/user.dart';
import 'package:agent/widget/header.dart';
import 'package:agent/widget/key_input_view.dart';
import 'package:agent/widget/page_widget.dart';
import 'package:agent/widget/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:get/get.dart';

import '../common/colors.dart';
import '../controller/user_controller.dart';
import '../widget/key_value_view.dart';
import '../widget/loader.dart';
import 'recharge_user_details.dart';

class RechargeRecord extends StatefulWidget {
  const RechargeRecord({Key? key}) : super(key: key);

  @override
  State<RechargeRecord> createState() => _RechargeRecordState();
}

class _RechargeRecordState extends State<RechargeRecord> {
  final loaderController = LoaderController();

  final startTime = DateTime.now().format(format: "yyyy-MM-dd").obs;
  final endTime = DateTime.now().format(format: "yyyy-MM-dd").obs;

  final data = {}.obs;

  @override
  void initState() {
    super.initState();

    refresh();
  }

  void refresh() {
    getData(refresh: true);
  }

  void getData({bool refresh = false}) {
    if (refresh) {
      loaderController.loading();
    }

    UserController().getRechargeRecord(
        startTime: startTime.value,
        endTime: endTime.value,
        success: (res) {
          data(res);
          loaderController.loadFinish();
          data.refresh();
        });
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        titleLabel: "充值报表",
        body: Column(
          children: [
            getHeader(),
            getContent().expanded(),
          ],
        ));
  }

  final orderId = TextEditingController();
  Widget getHeader() {
    return Header(callBack: (s, e, i) {
      startTime(s);
      endTime(e);
      refresh();
    });
  }

  Widget getContent() {
    return Obx(() {
      List dataList = data["top"] ?? [];
      Map user = {"counts": 0, "zhan": 0, "is_agent": 0},
          agent = {"counts": 0, "zhan": 0, "is_agent": 1};
      for (final temp in dataList) {
        if (temp["is_agent"] == 0) {
          user = temp;
        } else if (temp["is_agent"] == 1) {
          agent = temp;
        }
      }
      return Loader(
          controller: loaderController,
          child: SingleChildScrollView(
            child: Column(
              children: [
                getItem(user),
                getItem(agent),
              ],
            ),
          ));
    });
  }

  Widget getItem(item) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ((item["is_agent"] ?? 0) == 0 ? '直属会员分红' : '直属代理分红')
                .t
                .s(16)
                .c(DSColors.white)
                .color(
                    (item["is_agent"] ?? 0) == 0 ? Colors.green : Colors.orange)
                .padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2))
                .borderRadius(radius: 4),
          ],
        ),
        10.v,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            "充值笔数:${item["counts"] ?? 0}".t.s(16).c(DSColors.title),
            "返点:${item["zhan_moneys"] ?? 0}".t.s(16).c(DSColors.title),
          ],
        )
      ],
    )
        .padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10))
        .border(color: DSColors.primaryColor)
        .margin(margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12))
        .onTap(() {
      if (item["is_agent"] == 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => RechargeAgentDetails(
                      parentId: item["parent_id"],
                      startTime: startTime.value,
                      endTime: endTime.value,
                    )));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => RechargeUserDetails(
                      parentId: item["parent_id"],
                      startTime: startTime.value,
                      endTime: endTime.value,
                    )));
      }
    });
  }

  void showTime(type) {
    Picker(
        adapter: DateTimePickerAdapter(
          type: PickerDateTimeType.kYMD,
          isNumberMonth: true,
          yearSuffix: "年",
          monthSuffix: "月",
          daySuffix: "日",
          value: DateTime.parse(type == 0 ? startTime.value : endTime.value),
          maxValue: type == 0 ? DateTime.parse(endTime.value) : null,
          minValue: type == 1 ? DateTime.parse(startTime.value) : null,
        ),
        confirmText: "确定",
        cancelText: "取消",
        confirmTextStyle: TextStyle(color: DSColors.primaryColor, fontSize: 14),
        cancelTextStyle: TextStyle(color: DSColors.title, fontSize: 14),
        onConfirm: (picker, selectIndex) {
          DateTime temp = (picker.adapter as DateTimePickerAdapter)
              .value!
              .copyWith(hour: 0, minute: 0, second: 0);
          if (type == 0) {
            startTime(temp.format(format: "yyyy-MM-dd"));
          } else {
            endTime(temp.format(format: "yyyy-MM-dd"));
          }
          refresh();
        }).showModal<dynamic>(context);
  }
}
