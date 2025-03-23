import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/timesheet_controller.dart';
import 'package:timesheet/controller/tracking_controller.dart';
import 'package:timesheet/screen/tabs/time_sheet/widget/calendar_widget.dart';
import 'package:timesheet/screen/tabs/time_sheet/widget/pageview_widget.dart';
import 'package:timesheet/view/custom_button.dart';

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
            await Get.find<TimeSheetController>().init();
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
                          onPressed: () async {
                            if (timeSheetController.attendanced == false)
                              await timeSheetController.checkIn();
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
              if (timeSheetController.isLoading)
                const Center(
                    child: CircularProgressIndicator(color: Colors.blueAccent)),
            ],
          );
        },
      ),
    );
  }
}
