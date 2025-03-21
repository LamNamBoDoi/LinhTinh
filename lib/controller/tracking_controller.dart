import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/traking.dart';
import 'package:timesheet/data/repository/tracking_repo.dart';

class TrackingController extends GetxController implements GetxService {
  final TrackingRepo repo;
  TrackingController({required this.repo});
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool change = false;
  List<Tracking> listTrackingDay = <Tracking>[];

  List<Tracking> _listTracking = <Tracking>[];

  List<Tracking> get listTracking => _listTracking;

  void changed(bool change) {
    this.change = change;
    update();
  }

  Future<void> getTrackingDate(DateTime selectedDay) async {
    await getTracking();
    listTrackingDay.clear();
    for (Tracking tracking in _listTracking) {
      if (isSameDay(
          DateTime.fromMillisecondsSinceEpoch(tracking.date!), selectedDay)) {
        listTrackingDay.add(tracking);
      }
    }
    update();
  }

  Future<int> getTracking() async {
    _isLoading = true;
    update();
    Response response = await repo.getAllTracking();

    debugPrint("getTracking: ${response.statusCode}");
    if (response.statusCode == 200) {
      List<Tracking> convertListTracking = (response.body as List<dynamic>)
          .map((json) => Tracking.fromJson(json))
          .toList();
      _listTracking = convertListTracking;
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();

    return response.statusCode!;
  }

  Future<int> addTracking(String content, DateTime date) async {
    _isLoading = true;
    update();
    Tracking tracking = Tracking(
        id: null,
        content: content,
        date: date.millisecondsSinceEpoch,
        user: null);

    Response response = await repo.addTracking(tracking);
    debugPrint("addTracking: ${response.statusCode}");
    if (response.statusCode == 200) {
      Tracking tracking = Tracking.fromJson(response.body);
      _listTracking.add(tracking);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();

    return response.statusCode!;
  }

  Future<int> updateTracking(
      Tracking tracking, String content, DateTime date) async {
    _isLoading = true;
    update();

    tracking.content = content;
    tracking.date = date.millisecondsSinceEpoch;

    Response response = await repo.updateTracking(tracking.id, tracking);
    debugPrint("updateTracking: ${response.statusCode}");

    if (response.statusCode == 200) {
      Tracking trackingUpdate = Tracking.fromJson(response.body);

      _listTracking.forEach((element) {
        if (element.id == trackingUpdate.id) {
          element = trackingUpdate;
          return;
        }
      });
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();

    return response.statusCode!;
  }

  Future<int> deleteTracking(Tracking tracking) async {
    _isLoading = true;
    update();

    debugPrint("delete:");
    Response response = await repo.deleteTracking(tracking.id);
    debugPrint("delete: ${response.statusCode}");

    if (response.statusCode == 200) {
      Tracking? trackingDelete = Tracking.fromJson(response.body);
      int index = _listTracking.indexOf(trackingDelete);
      if (index != -1) {
        _listTracking.removeAt(index);
      }
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();

    return response.statusCode!;
  }
}
