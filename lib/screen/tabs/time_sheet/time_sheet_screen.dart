import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timesheet/controller/timesheet_controller.dart';
import 'package:timesheet/controller/tracking_controller.dart';
import 'package:timesheet/data/model/body/time_sheet.dart';
import 'package:timesheet/data/model/body/traking.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/screen/tabs/tracking/tracking_screen.dart';
import 'package:timesheet/utils/color_resources.dart';
import 'package:timesheet/utils/dimensions.dart';
import 'package:timesheet/view/custom_button.dart';
import 'package:timesheet/view/custom_snackbar.dart';

class TimeSheetScreen extends StatefulWidget {
  TimeSheetScreen({super.key});

  @override
  State<TimeSheetScreen> createState() => _TimeSheetScreenState();
}

class _TimeSheetScreenState extends State<TimeSheetScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focuseDay = DateTime.now();
  RxBool attendanced = false.obs;
  TrackingController trackingController = Get.find<TrackingController>();
  Future<void> _onRefresh() {
    return Get.find<TimeSheetController>().getTimeSheet();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Column(
          children: [
            Container(
              child: GetBuilder<TimeSheetController>(initState: (_) {
                Get.find<TimeSheetController>().getTimeSheet().then((_) {
                  checkTodayAttendenced(
                      Get.find<TimeSheetController>().getEventsCalendar());
                  Get.find<TimeSheetController>()
                      .handleProgressInMonth(_focuseDay);
                  trackingController.getTracking();
                });
              }, builder: (controller) {
                Map<DateTime, List<TimeSheet>> _events =
                    controller.getEventsCalendar();
                return TableCalendar(
                  focusedDay: _focuseDay,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2025, 12, 31),
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focuseDay = focusedDay;
                      });
                      checkTodayAttendenced(_events);
                      getTrackingDate();
                    }
                  },
                  onPageChanged: (focusedDay) {
                    controller.handleProgressInMonth(focusedDay);
                  },
                  eventLoader: (day) {
                    DateTime dayCompare =
                        DateTime(day.year, day.month, day.day).toLocal();

                    return _events[dayCompare] ?? [];
                  },
                  headerStyle: const HeaderStyle(
                      formatButtonVisible: false, titleCentered: true),
                  availableGestures: AvailableGestures.all,
                  calendarStyle: CalendarStyle(
                    weekendTextStyle: const TextStyle(color: Colors.red),
                    todayTextStyle: const TextStyle(color: Colors.black),
                    selectedDecoration: BoxDecoration(
                        color: ColorResources.ssColor[4],
                        shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorResources.ssColor[2],
                        width: 1.0,
                      ),
                    ),
                  ),
                );
              }),
            ),
            Expanded(
              child: PageView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      height: height / 4 + 25,
                      width: width - 20,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFD7F9FA),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Obx(() => Text(
                                  "${"total_day".tr}: ${Get.find<TimeSheetController>().totalDayCheckinInMonth.value.toInt()}/${Get.find<TimeSheetController>().totalDayInMonth.value.toInt()}",
                                  style: const TextStyle(
                                    color: Color(0xFF0C5776),
                                    fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Obx(() {
                              return LinearPercentIndicator(
                                width: MediaQuery.of(context).size.width - 50,
                                animation: true,
                                lineHeight: 20.0,
                                barRadius: Radius.circular(15),
                                animationDuration: 2000,
                                percent: Get.find<TimeSheetController>()
                                    .progressRate
                                    .value,
                                center: Text(
                                  "${(Get.find<TimeSheetController>().progressRate.value * 10000).round() / 100}%",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0C5776)),
                                ),
                                progressColor: Color(0xFF0C5776),
                              );
                            })
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                        width: width - 20,
                        height: height / 4 + 25,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xFFB6DDDA),
                          borderRadius: BorderRadius.circular(15),
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
                                      color: Color(0xFF01877E),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Obx(
                                    () => Center(
                                      child: Text(
                                        trackingController
                                            .listTrackingDay.length
                                            .toString(), // Hiển thị số lượng tracking
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                                child: ListView.builder(
                                    itemCount: trackingController
                                        .listTrackingDay.length,
                                    itemBuilder: (context, index) {
                                      Tracking tracking = trackingController
                                          .listTrackingDay[index];
                                      return ListTile(
                                        onTap: () =>
                                            showDialogTracking(tracking),
                                        title: Container(
                                          height: 40,
                                          width: 100,
                                          child: Row(
                                            children: [
                                              Text(
                                                DateConverter.dateTimeHourFormat
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            tracking.date!)),
                                                style: const TextStyle(
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_DEFAULT,
                                                    color: Color(0xFF01877E),
                                                    fontWeight:
                                                        FontWeight.w500),
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
                                                tracking.content!,
                                                style: const TextStyle(
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_DEFAULT,
                                                    color: Color(0xFF01877E),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }))
                          ],
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Obx(
                    () => CustomButton(
                      off: attendanced.value,
                      onPressed: () {
                        if (attendanced == false) handleCheckin();
                        _onRefresh();
                      },
                      width: 180,
                      height: 50,
                      radius: 20,
                      buttonText: "Điểm danh",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Obx(() {
          return Center(
            child: Visibility(
              visible: Get.find<TimeSheetController>().isLoading.value,
              child: const CircularProgressIndicator(),
            ),
          );
        })
      ],
    );
  }

  void handleCheckin() {
    Get.find<TimeSheetController>().checkIn().then((value) {
      attendanced.value = true;

      if (value == 200 || value == 201) {
        showCustomSnackBar("success".tr);
      } else {
        showCustomSnackBar("faild".tr);
      }
    });
  }

  void checkTodayAttendenced(Map<DateTime, List<TimeSheet>> _events) {
    DateTime dayCompare =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .toLocal();
    if (isSameDay(_selectedDay, DateTime.now())) {
      if (_events[dayCompare] != null) {
        attendanced.value = true;
      } else {
        attendanced.value = false;
      }
    } else {
      attendanced.value = true;
    }
  }

  List<Tracking> getTrackingDate() {
    trackingController.getTracking();
    trackingController.listTrackingDay.clear();
    for (Tracking tracking in trackingController.listTracking) {
      if (isSameDay(
          DateTime.fromMillisecondsSinceEpoch(tracking.date!), _selectedDay)) {
        trackingController.listTrackingDay.add(tracking);
      }
    }
    print(trackingController.listTrackingDay.length);
    return trackingController.listTrackingDay;
  }

  void showDialogTracking(Tracking tracking) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            title: Container(
              height: 40,
              decoration: const BoxDecoration(
                  color: Color(0xFF01877E),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              child: const Center(
                child: const Text(
                  "Tracking",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            content: Container(
              height: 100,
              width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "time".tr +
                        ": " +
                        DateConverter.dateTimeHourFormat.format(
                            DateTime.fromMillisecondsSinceEpoch(
                                tracking.date!)),
                    style: const TextStyle(
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                        color: Color(0xFF01877E),
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Tracking" + ": " + tracking.content!,
                    style: const TextStyle(
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                        color: Color(0xFF01877E),
                        fontWeight: FontWeight.w600),
                  ),
                  Expanded(
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
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
