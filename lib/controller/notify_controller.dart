import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/notify.dart';
import 'package:timesheet/data/repository/notify_repo.dart';

class NotifyController extends GetxController implements GetxService {
  final NotifyRepo repo;
  NotifyController({required this.repo});

  List<Notify> _listNotifys = <Notify>[];
  bool _loading = false;
  bool get loading => _loading;
  List<Notify> get listNotifys => _listNotifys;

  Future<int?> getNotify() async {
    _loading = true;
    update();

    Response response = await repo.getNotify();
    debugPrint("getNotify: ${response.statusCode}");

    if (response.statusCode == 200) {
      List<dynamic> jsonData = response.body; // Lấy dữ liệu JSON từ API

      _listNotifys = jsonData.map((item) => Notify.fromJson(item)).toList();
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    update();
    return response.statusCode;
  }
}
