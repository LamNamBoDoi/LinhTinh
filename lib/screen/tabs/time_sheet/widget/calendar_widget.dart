import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timesheet/controller/timesheet_controller.dart';
import 'package:timesheet/controller/tracking_controller.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget(
      {required this.timeSheetController,
      required this.trackingController,
      super.key});
  final TimeSheetController timeSheetController;
  final TrackingController trackingController;
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: timeSheetController.focusedDay,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2025, 12, 31),
      selectedDayPredicate: (day) =>
          isSameDay(day, timeSheetController.selectedDay),
      onDaySelected: (selectedDay, focusedDay) {
        timeSheetController.updateSelectedDay(selectedDay, focusedDay);
        trackingController.getTrackingDate(selectedDay);
        timeSheetController.checkTodayAttendenced(timeSheetController);
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
}
