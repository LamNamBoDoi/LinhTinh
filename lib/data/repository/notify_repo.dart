import 'package:get/get.dart';
import 'package:timesheet/data/api/api_client.dart';
import 'package:timesheet/utils/app_constants.dart';

class NotifyRepo {
  ApiClient apiClient;
  NotifyRepo({required this.apiClient});

  Future<Response> getNotify() async {
    return await apiClient.getData(AppConstants.GET_NOTIFY);
  }
}
