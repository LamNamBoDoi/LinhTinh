import 'dart:convert';

import 'package:get/get.dart';
import 'package:timesheet/data/api/api_client.dart';
import 'package:timesheet/utils/app_constants.dart';

class TrackingRepo {
  ApiClient apiClient;

  TrackingRepo({required this.apiClient});

  Future<Response> getAllTracking() async =>
      await apiClient.getData(AppConstants.GET_TRACKING);
  Future<Response> addTracking(tracking) async => await apiClient.postData(
      AppConstants.GET_TRACKING, jsonEncode(tracking), null);
  Future<Response> updateTracking(id, tracking) async => await apiClient
      .postData("${AppConstants.GET_TRACKING}/$id", jsonEncode(tracking), null);
  Future<Response> deleteTracking(id) async => await apiClient
      .deleteData("${AppConstants.GET_TRACKING}/$id", headers: null);
}
