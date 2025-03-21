import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/tracking_controller.dart';
import 'package:timesheet/data/model/body/traking.dart';
import 'package:timesheet/helper/route_helper.dart';
import 'package:timesheet/view/custom_snackbar.dart';

class SelectDeleteWidget extends StatelessWidget {
  SelectDeleteWidget({
    super.key,
    required this.trackingController,
    required this.tracking,
  });

  final TrackingController trackingController;
  final Tracking? tracking;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
      borderRadius: BorderRadius.circular(12), // Bo tròn góc
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Khoảng cách
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.15), // Màu nền nhẹ
          borderRadius: BorderRadius.circular(12), // Bo tròn góc
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow nhẹ
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Chỉ chiếm không gian cần thiết
          children: [
            Icon(
              Icons.delete,
              color: Colors.redAccent, // Màu icon
              size: 24,
            ),
            SizedBox(width: 8), // Khoảng cách giữa icon và văn bản
            Text(
              "delete".tr, // Văn bản "Xóa"
              style: TextStyle(
                color: Colors.redAccent, // Màu văn bản
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
