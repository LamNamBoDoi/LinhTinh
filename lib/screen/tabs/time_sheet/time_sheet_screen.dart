import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timesheet/controller/timesheet_controller.dart';
import 'package:timesheet/controller/tracking_controller.dart';
import 'package:timesheet/data/model/body/traking.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/screen/tabs/tracking/tracking_screen.dart';
import 'package:timesheet/utils/dimensions.dart';
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
              _checkTodayAttendenced(Get.find<TimeSheetController>());
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
                  _buildCalendar(
                      timeSheetController, trackingController, context),
                  Divider(
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  _buildPageView(height, width, context, timeSheetController),
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
              if (timeSheetController.isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black
                        .withOpacity(0.5), // Add a background overlay
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void handleCheckin(TimeSheetController timeSheetController) {
    timeSheetController.checkIn().then((value) {
      if (value == 200 || value == 201) {
        showCustomSnackBar("success".tr);
      } else {
        showCustomSnackBar("faild".tr);
      }
    });
  }

  Widget _buildPageView(double height, double width, BuildContext context,
      TimeSheetController timeSheetController) {
    return Expanded(
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
                      barRadius: Radius.circular(15),
                      animationDuration: 2000,
                      percent: timeSheetController.progressRate,
                      center: Text(
                        "${(timeSheetController.progressRate * 10000).round() / 100}%",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0C5776)),
                      ),
                      progressColor: Color(0xFF0C5776),
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
              padding: EdgeInsets.symmetric(horizontal: 10),
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
                            color: Color(0xFF01877E),
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

  Widget _buildCalendar(TimeSheetController timeSheetController,
      TrackingController trackingController, BuildContext context) {
    return TableCalendar(
      focusedDay: timeSheetController.focusedDay,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2025, 12, 31),
      selectedDayPredicate: (day) =>
          isSameDay(day, timeSheetController.selectedDay),
      onDaySelected: (selectedDay, focusedDay) {
        timeSheetController.updateSelectedDay(selectedDay, focusedDay);
        trackingController.getTrackingDate(selectedDay);
        _checkTodayAttendenced(timeSheetController);
      },
      eventLoader: (day) {
        DateTime dayCompare = DateTime(day.year, day.month, day.day).toLocal();
        return timeSheetController.events[dayCompare] ?? [];
      },
      onPageChanged: (focusedDay) {
        timeSheetController.updateFocusedDay(focusedDay);
        timeSheetController.handleProgressInMonth(focusedDay);
      },
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: 18,
            fontWeight: FontWeight.w600),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: 15,
            fontWeight: FontWeight.w400),
        weekendStyle: TextStyle(
            color: Colors.red, fontSize: 15, fontWeight: FontWeight.w400),
      ),
      availableGestures: AvailableGestures.all,
      calendarStyle: CalendarStyle(
        markerDecoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          shape: BoxShape.circle,
        ),
        defaultTextStyle: Theme.of(context).textTheme.bodyLarge!,
        weekendTextStyle: const TextStyle(color: Colors.red),
        todayTextStyle: const TextStyle(color: Colors.green),
        selectedDecoration: BoxDecoration(
            color: Theme.of(context).hintColor, shape: BoxShape.circle),
        todayDecoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).secondaryHeaderColor,
            width: 1.0,
          ),
        ),
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

  void _checkTodayAttendenced(TimeSheetController timeSheetController) {
    DateTime dayCompare =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .toLocal();
    if (isSameDay(timeSheetController.selectedDay, DateTime.now())) {
      if (timeSheetController.events[dayCompare] != null) {
        timeSheetController.attendanced = true;
      } else {
        timeSheetController.attendanced = false;
      }
    } else {
      timeSheetController.attendanced = true;
    }
  }
}
