import 'dart:convert';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:timesheet/data/api/api_client.dart';
import 'package:timesheet/data/model/body/users/user.dart';
import 'package:timesheet/utils/app_constants.dart';

class UserRepo {
  final ApiClient apiClient;
  UserRepo({required this.apiClient});

  Future<Response> getListUsersPage(
      String keyWord, int pageIndex, int size, int status) async {
    return await apiClient.postData(
      AppConstants.GET_USERS,
      jsonEncode({
        "keyWord": keyWord,
        "pageIndex": pageIndex,
        "size": size,
        "status": status
      }),
      null,
    );
  }

  Future<Response> getCurrentUser() async {
    return await apiClient.getData(AppConstants.GET_USER);
  }

  Future<Response> getUserById(int userId) async {
    return await apiClient.getData("${AppConstants.GET_USER_BY_ID}$userId");
  }

  Future<Response> updateUserMySelf(User user) async {
    return await apiClient.postData(
        AppConstants.UPDATE_USER_MYSELF, jsonEncode(user), null);
  }

  Future<Response> updateUserById(User user) async {
    return await apiClient.postData(
        "${AppConstants.UPDATE_USER_BY_ID}${user.id}", jsonEncode(user), null);
  }

  Future<Response> blockUser(String userId) async {
    return await apiClient
        .getData("${AppConstants.UPDATE_BLOCK_USER_BY_ID}$userId");
  }

  Future<Response> updateTokenDevice(String tokenDevice) async {
    return await apiClient.getData(
        "${AppConstants.UPDATE_TOKEN_DEVICE}?tokenDevice=$tokenDevice");
  }
}
