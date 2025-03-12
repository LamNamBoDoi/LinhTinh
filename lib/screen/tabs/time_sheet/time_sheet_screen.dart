import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/timesheet_controller.dart';
import 'package:timesheet/controller/tracking_controller.dart';
import 'package:timesheet/screen/tabs/time_sheet/widget/calendar_widget.dart';
import 'package:timesheet/screen/tabs/time_sheet/widget/pageview_widget.dart';
import 'package:timesheet/view/custom_button.dart';
import 'package:timesheet/view/custom_snackbar.dart';

class TimeSheetScreen extends StatelessWidget {
  const TimeSheetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TrackingController trackingController = Get.find<TrackingController>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<TimeSheetController>(
        initState: (state) async {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await Get.find<TimeSheetController>().init().then((value) {
              Get.find<TimeSheetController>()
                  .checkTodayAttendenced(Get.find<TimeSheetController>());
            });
            await Get.find<TrackingController>()
                .getTrackingDate(DateTime.now());
          });
        },
        builder: (timeSheetController) {
          return Stack(
            children: [
              Column(
                children: [
                  CalendarWidget(
                      timeSheetController: timeSheetController,
                      trackingController: trackingController),
                  Divider(
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  PageviewWidget(
                      height: height,
                      width: width,
                      timeSheetController: timeSheetController),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomButton(
                          off: timeSheetController.attendanced,
                          onPressed: () {
                            if (timeSheetController.attendanced == false)
                              handleCheckin(timeSheetController);
                          },
                          width: 180,
                          height: 50,
                          radius: 20,
                          buttonText: "roll_call".tr,
                        )
                      ],
                    ),
                  )
                ],
              ),
              // if (timeSheetController.isLoading)
              //   Positioned.fill(
              //     child: Container(
              //       color: Colors.black
              //           .withOpacity(0.5), // Add a background overlay
              //       child: Center(
              //         child: CircularProgressIndicator(),
              //       ),
              //     ),
              //   ),
            ],
          );
        },
      ),
    );
  }

  void handleCheckin(TimeSheetController timeSheetController) {
    timeSheetController.checkIn().then((value) {
      if (value == 200 || value == 201) {
        showCustomSnackBar("success".tr, isError: false);
      } else {
        showCustomSnackBar("faild".tr);
      }
    });
  }
}
