import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:timesheet/data/model/body/time_sheet.dart';
import 'package:timesheet/data/repository/timesheet_repo.dart';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../data/api/api_checker.dart';

class TimeSheetController extends GetxController implements GetxService {
  final TimeSheetRepo repo;
  TimeSheetController({required this.repo});

  RxBool _isLoading = false.obs;
  RxBool get isLoading => _isLoading;

  List<TimeSheet> _timeSheets = <TimeSheet>[];
  List<TimeSheet> get timeSheets => _timeSheets;

  RxDouble totalDayInMonth = 0.0.obs;
  RxDouble totalDayCheckinInMonth = 0.0.obs;
  RxDouble progressRate = 0.0.obs;

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
      progressRate.value =
          ((100 / myTotalDayInMonth) * myTotalDayCheckInMonth) / 100;
      totalDayInMonth.value = myTotalDayInMonth;
      totalDayCheckinInMonth.value = myTotalDayCheckInMonth;
    }
  }

  Map<DateTime, List<TimeSheet>> getEventsCalendar() {
    Map<DateTime, List<TimeSheet>> _event = {};
    for (var element in _timeSheets) {
      DateTime? dateTime =
          DateTime.fromMillisecondsSinceEpoch(element.dateAttendance!);

      DateTime key =
          DateTime(dateTime.year, dateTime.month, dateTime.day).toLocal();
      _event[key] = [element];
    }
    return _event;
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
    _isLoading.value = true;

    String? wifiIP = await getWifiIP();
    Response response = await repo.checkInTimeSheet(wifiIP.toString());
    print(response.body);
    if (response.statusCode == 200) {
      TimeSheet? timeSheet = TimeSheet.fromJson(response.body);

      timeSheets.add(timeSheet);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading.value = false;

    return response.statusCode!;
  }

  Future<int> getTimeSheet() async {
    // _isLoading.value = true;

    Response response = await repo.getTimeSheet();
    if (response.statusCode == 200) {
      print(response.body);

      List<TimeSheet> convertListTimeSheets = (response.body as List<dynamic>)
          .map((json) => TimeSheet.fromJson(json))
          .toList();

      _timeSheets = convertListTimeSheets;
      //handleProgressInMonth(DateTime.now());
    } else {
      ApiChecker.checkApi(response);
    }
    // _isLoading.value = false;

    return response.statusCode!;
  }
}
