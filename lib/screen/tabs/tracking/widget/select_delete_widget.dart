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
            trackingController.deleteTracking(tracking!);
            Get.offAllNamed(RouteHelper.home);
          },
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.delete,
              color: Colors.redAccent,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              "delete".tr,
              style: TextStyle(
                color: Colors.redAccent,
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
