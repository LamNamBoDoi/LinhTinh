import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/tracking_controller.dart';
import 'package:timesheet/data/model/body/traking.dart';
import 'package:timesheet/helper/route_helper.dart';
import 'package:timesheet/view/custom_snackbar.dart';

class SelectDeleteWidget extends StatelessWidget {
  SelectDeleteWidget(
      {super.key, required this.trackingController, required this.tracking});
  final TrackingController trackingController;
  final Tracking? tracking;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showCustomConfirm(
            context,
            'do_you_want_to_delete?'.tr,
            () {
              trackingController.deleteTracking(tracking!).then((value) {
                if (value == 200 || value == 201) {
                  showCustomSnackBar("success".tr, isError: false);
                } else {
                  showCustomSnackBar("fail".tr, isError: true);
                }
              });
              Get.offAllNamed(RouteHelper.home);
            },
          );
        },
        child: Container(
          padding: EdgeInsets.all(8), // Khoảng cách giữa icon và viền tròn
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.redAccent.withOpacity(0.15), // Màu nền nhẹ
          ),
          child: const Icon(
            Icons.delete,
            color: Colors.redAccent,
            size: 28,
          ),
        ));
  }
}
