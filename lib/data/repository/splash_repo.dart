import 'package:timesheet/utils/app_constants.dart';
import '../api/api_client.dart';
import 'package:get/get.dart';

class SplashRepo {
  final ApiClient apiClient;

  SplashRepo({required this.apiClient});

  Future<Response> getConfig() {
    return apiClient.getData(AppConstants.CONFIG_URI);
  }

}
