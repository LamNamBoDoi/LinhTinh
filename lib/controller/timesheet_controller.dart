import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timesheet/data/model/body/time_sheet.dart';
import 'package:timesheet/data/repository/timesheet_repo.dart';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../data/api/api_checker.dart';

class TimeSheetController extends GetxController implements GetxService {
  final TimeSheetRepo repo;
  TimeSheetController({required this.repo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool attendanced = false;
  List<TimeSheet> _timeSheets = <TimeSheet>[];
  List<TimeSheet> get timeSheets => _timeSheets;

  double totalDayInMonth = 0.0;
  double totalDayCheckinInMonth = 0.0;
  double progressRate = 0.0;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  Map<DateTime, List<TimeSheet>> _events = {};
  Map<DateTime, List<TimeSheet>> get events => _events;
  void updateSelectedDay(DateTime selectedDay, DateTime focusedDay) {
    this.selectedDay = selectedDay;
    this.focusedDay = focusedDay; // Cập nhật lại ngày khi người dùng chọn
    update(); // Cập nhật UI
  }

  void updateFocusedDay(DateTime focusedDay) {
    this.focusedDay = focusedDay;
    update(); // Cập nhật UI khi người dùng lướt qua tháng/năm
  }

  void handleProgressInMonth(DateTime dateTime) {
    double myTotalDayInMonth =
        DateTime(dateTime.year, dateTime.month + 1, 0).day.toDouble();
    double myTotalDayCheckInMonth = 0;

    for (var time in timeSheets) {
      DateTime? dateCheckin =
          DateTime.fromMillisecondsSinceEpoch(time.dateAttendance!);
      if (dateTime.year == dateCheckin.year &&
          dateTime.month == dateCheckin.month) {
        myTotalDayCheckInMonth += 1;
      }
      progressRate = ((100 / myTotalDayInMonth) * myTotalDayCheckInMonth) / 100;
      totalDayInMonth = myTotalDayInMonth;
      totalDayCheckinInMonth = myTotalDayCheckInMonth;
    }
    update();
  }

  void getEventsCalendar() {
    for (var element in _timeSheets) {
      DateTime? dateTime =
          DateTime.fromMillisecondsSinceEpoch(element.dateAttendance!);

      DateTime key =
          DateTime(dateTime.year, dateTime.month, dateTime.day).toLocal();
      _events[key] = [element];
    }
    update();
  }

  init() async {
    selectedDay = DateTime.now();
    focusedDay = DateTime.now();
    update();
    await getTimeSheet();
    getEventsCalendar();
  }

  Future<String?> getWifiIP() async {
    try {
      // Kiểm tra kết nối mạng
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.wifi) {
        // Lấy danh sách các Network Interface
        var interfaces = await NetworkInterface.list();
        for (var interface in interfaces) {
          // Lặp qua các địa chỉ IP của interface
          for (var address in interface.addresses) {
            if (address.address != '127.0.0.1' &&
                address.address.contains('.')) {
              return address.address; // Trả về địa chỉ IP
            }
          }
        }
      } else {
        print("Không kết nối Wi-Fi.");
      }
    } catch (e) {
      print("Lỗi khi lấy địa chỉ IP: $e");
    }
    return null;
  }

  Future<int> checkIn() async {
    _isLoading = true;
    update();
    String? wifiIP = await getWifiIP();
    Response response = await repo.checkInTimeSheet(wifiIP.toString());
    debugPrint("checkIn: ${response.statusCode}");

    if (response.statusCode == 200) {
      TimeSheet? timeSheet = TimeSheet.fromJson(response.body);
      attendanced = true;
      timeSheets.add(timeSheet);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
    return response.statusCode!;
  }

  Future<int> getTimeSheet() async {
    _isLoading = true;
    update();
    Response response = await repo.getTimeSheet();
    debugPrint("getTimeSheet: ${response.statusCode}");

    if (response.statusCode == 200) {
      List<TimeSheet> convertListTimeSheets = (response.body as List<dynamic>)
          .map((json) => TimeSheet.fromJson(json))
          .toList();

      _timeSheets = convertListTimeSheets;
      handleProgressInMonth(DateTime.now());
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
    return response.statusCode!;
  }

  void checkTodayAttendenced(TimeSheetController timeSheetController) {
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
