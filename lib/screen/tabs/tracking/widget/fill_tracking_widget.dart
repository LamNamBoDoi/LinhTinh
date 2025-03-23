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
  const FillTrackingWidget(
      {required this.trackingController,
      required this.contentController,
      required this.update,
      required this.tracking,
      required this.timeSelect,
      super.key,
      required this.formKey});
  final TrackingController trackingController;
  final TextEditingController contentController;
  final bool? update;
  final Tracking? tracking;
  final DateTime timeSelect;
  final GlobalKey<FormState> formKey;

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
        const SizedBox(
          height: 20,
        ),
        CustomTextField(
          width: MediaQuery.of(context).size.width - 20,
          validator: (value) =>
              value!.isEmpty ? 'please_fill_tracking'.tr : null,
          height: 80,
          controller: contentController,
          radius: const Radius.circular(15),
          lable: "Tracking",
          onChange: (text) {
            trackingController.changed(true);
          },
        ),
        const SizedBox(height: 40),
        CustomButton(
          buttonText: update == true ? "save".tr : "create".tr,
          onPressed: () => _createUpdateTracking(trackingController),
        ),
      ],
    );
  }

  void _createUpdateTracking(TrackingController trackingController) {
    if (update == null || update == false) {
      print(formKey.currentState!.validate());
      if (formKey.currentState!.validate()) {
        trackingController
            .addTracking(contentController.text, timeSelect)
            .then((value) {
          if (value == 200 || value == 201) {
            contentController.text = '';
          }
        });
      } else {
        showCustomFlash("please_fill_in_completely".tr, Get.context!,
            isError: true);
        return;
      }
    } else {
      if (trackingController.change == true) {
        if (formKey.currentState!.validate()) {
          trackingController.updateTracking(
              tracking!, contentController.text, timeSelect);
        } else {
          showCustomFlash("please_fill_in_completely".tr, Get.context!,
              isError: true);
          return;
        }
      }
    }
    Get.offAllNamed(RouteHelper.home);
  }
}
