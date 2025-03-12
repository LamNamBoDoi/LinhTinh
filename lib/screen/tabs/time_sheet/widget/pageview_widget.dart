import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:timesheet/controller/timesheet_controller.dart';
import 'package:timesheet/controller/tracking_controller.dart';
import 'package:timesheet/data/model/body/traking.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/screen/tabs/tracking/tracking_screen.dart';
import 'package:timesheet/utils/dimensions.dart';
import 'package:timesheet/view/custom_button.dart';

class PageviewWidget extends StatelessWidget {
  PageviewWidget(
      {required this.height,
      required this.width,
      required this.timeSheetController,
      super.key});
  final double height;
  final double width;
  final TimeSheetController timeSheetController;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: height / 4 + 25,
              width: width - 20,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFFD7F9FA),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "${"total_day".tr}: ${timeSheetController.totalDayCheckinInMonth.toInt()}/${timeSheetController.totalDayInMonth.toInt()}",
                      style: const TextStyle(
                        color: Color(0xFF0C5776),
                        fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 50,
                      animation: true,
                      lineHeight: 20.0,
                      barRadius: const Radius.circular(15),
                      animationDuration: 2000,
                      percent: timeSheetController.progressRate,
                      center: Text(
                        "${(timeSheetController.progressRate * 10000).round() / 100}%",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0C5776)),
                      ),
                      progressColor: const Color(0xFF0C5776),
                    )
                  ],
                ),
              ),
            ),
          ),
          GetBuilder<TrackingController>(builder: (trackingController) {
            if (trackingController.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: width - 20,
                height: height / 4 + 25,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xFFB6DDDA),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Tracking",
                          style: TextStyle(
                            color: Color(0xFF01877E),
                            fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFF01877E),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              trackingController.listTrackingDay.length
                                  .toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount:
                                trackingController.listTrackingDay.length,
                            itemBuilder: (context, index) {
                              Tracking tracking =
                                  trackingController.listTrackingDay[index];
                              return ListTile(
                                onTap: () =>
                                    showDialogTracking(tracking, context),
                                title: Container(
                                  height: 40,
                                  width: 100,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateConverter.dateTimeHourFormat.format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                tracking.date!)),
                                        style: const TextStyle(
                                            fontSize:
                                                Dimensions.FONT_SIZE_DEFAULT,
                                            color: Color(0xFF01877E),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const VerticalDivider(
                                        color: Color(0xFF01877E),
                                        width: 1,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        tracking.content!.length > 35
                                            ? tracking.content!
                                                    .substring(0, 30) +
                                                "..."
                                            : tracking.content!,
                                        style: const TextStyle(
                                            fontSize:
                                                Dimensions.FONT_SIZE_DEFAULT,
                                            color: Color(0xFF01877E),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })),
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }

  void showDialogTracking(Tracking tracking, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          insetPadding: EdgeInsets.all(20),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Color(0xFF01877E),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Tracking",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Time: " +
                              DateConverter.dateTimeHourFormat.format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    tracking.date!),
                              ),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF01877E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              "Tracking: " + tracking.content!,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color(0xFF01877E),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        height: 50,
                        width: 50,
                        onPressed: () {
                          Get.to(() => TrackingScreen(
                                update: true,
                                tracking: tracking,
                              ));
                        },
                        off: false,
                        icon: Icons.edit,
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
