import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/traking.dart';
import 'package:timesheet/data/repository/tracking_repo.dart';

class TrackingController extends GetxController implements GetxService {
  final TrackingRepo repo;
  TrackingController({required this.repo});

  RxBool _isLoading = false.obs;
  RxBool get isLoading => _isLoading;
  RxList<Tracking> listTrackingDay = <Tracking>[].obs;

  var _listTracking = <Tracking>[];

  List<Tracking> get listTracking => _listTracking;

  Future<int> getTracking() async {
    // _isLoading.value = true;
    Response response = await repo.getAllTracking();

    debugPrint("okeoke: ${response.statusCode}");
    if (response.statusCode == 200) {
      List<Tracking> convertListTracking = (response.body as List<dynamic>)
          .map((json) => Tracking.fromJson(json))
          .toList();
      _listTracking = convertListTracking;
    } else {
      ApiChecker.checkApi(response);
    }
    // _isLoading.value = false;

    return response.statusCode!;
  }

  Future<int> addTracking(String content, DateTime date) async {
    _isLoading.value = true;

    Tracking tracking = Tracking(
        id: null,
        content: content,
        date: date.millisecondsSinceEpoch,
        user: null);

    Response response = await repo.addTracking(tracking);
    debugPrint("okeoke: ${response.statusCode}");
    if (response.statusCode == 200) {
      Tracking tracking = Tracking.fromJson(response.body);
      _listTracking.add(tracking);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading.value = false;

    return response.statusCode!;
  }

  Future<int> updateTracking(
      Tracking tracking, String content, DateTime date) async {
    _isLoading.value = true;

    tracking.content = content;
    tracking.date = date.millisecondsSinceEpoch;

    Response response = await repo.updateTracking(tracking.id, tracking);
    debugPrint("okeoke: ${response.statusCode}");

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
    _isLoading.value = false;

    return response.statusCode!;
  }

  Future<int> deleteTracking(Tracking tracking) async {
    _isLoading.value = true;

    debugPrint("delete:");
    Response response = await repo.deleteTracking(tracking.id);
    if (response.statusCode == 200) {
      Tracking? trackingDelete = Tracking.fromJson(response.body);
      int index = _listTracking.indexOf(trackingDelete);
      if (index != -1) {
        _listTracking.removeAt(index);
      }
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading.value = false;

    return response.statusCode!;
  }
}
