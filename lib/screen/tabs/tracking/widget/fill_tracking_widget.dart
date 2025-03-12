import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/tracking_controller.dart';
import 'package:timesheet/data/model/body/traking.dart';
import 'package:timesheet/utils/dimensions.dart';
import 'package:timesheet/view/custom_button.dart';
import 'package:timesheet/view/custom_snackbar.dart';
import 'package:timesheet/view/custom_text_field.dart';

import '../../../../helper/route_helper.dart';

class FillTrackingWidget extends StatelessWidget {
  FillTrackingWidget(
      {required this.trackingController,
      required this.contentController,
      required this.update,
      required this.tracking,
      required this.timeSelect,
      super.key});
  final TrackingController trackingController;
  final TextEditingController contentController;
  final bool? update;
  final Tracking? tracking;
  final DateTime timeSelect;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text("Tracking",
            style: TextStyle(
              fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
              fontWeight: FontWeight.w500,
            )),
        CustomTextField(
          width: MediaQuery.of(context).size.width - 20,
          height: 100,
          controller: contentController,
          radius: const Radius.circular(15),
          hintText: "Tracking",
          onChange: (text) {
            trackingController.changed(true);
          },
        ),
        const SizedBox(height: 40),
        CustomButton(
          buttonText: update == true ? "save".tr : "create".tr,
          onPressed: () => _createUpdateTracking(trackingController, context),
        ),
      ],
    );
  }

  void _createUpdateTracking(
      TrackingController trackingController, BuildContext context) {
    if (update == null || update == false) {
      if (contentController.text != "") {
        trackingController
            .addTracking(contentController.text, timeSelect)
            .then((value) {
          if (value == 200 || value == 201) {
            showCustomSnackBar("success".tr, isError: false);
            contentController.text = '';
          } else {
            showCustomSnackBar("fail".tr, isError: false);
          }
        });
      } else {
        showCustomSnackBar("fail".tr, isError: true);
      }
    } else {
      if (trackingController.change == true) {
        if (contentController.text != '') {
          trackingController
              .updateTracking(tracking!, contentController.text,
                  DateTime.fromMillisecondsSinceEpoch(tracking!.date!))
              .then((value) {
            if (value == 200 || value == 201) {
              showCustomSnackBar("success".tr, isError: false);
            } else {
              showCustomSnackBar("fail".tr, isError: true);
            }
          });
        } else {
          showCustomFlash("fail".tr, context, isError: true);
        }
      }
      Get.offAllNamed(RouteHelper.home);
    }
  }
}
