import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/users/pageable_response.dart';
import 'package:timesheet/data/model/body/users/user.dart';
import 'package:timesheet/data/repository/user_repo.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo repo;
  UserController({required this.repo});

  int currentPage = 1;
  bool isLastPage = false;
  bool _loading = false;
  bool isMyProfile = false;
  bool isAdmin = false;

  List<User> _listUsers = <User>[];
  List<User> _usersPage = <User>[];
  List<User> _usersPageCurrent = <User>[];
  User _currentUser = User();
  User? _currentUserProfile;

  bool get loading => _loading;
  User get currentUser => _currentUser;
  User? get currentUserProfile => _currentUserProfile;
  List<User> get listUsers => _listUsers;
  List<User> get usersPage => _usersPage;
  List<User> get usersPageCurrent => _usersPageCurrent;

  void resetDataProfile() {
    isAdmin = false;
    isMyProfile = false;
    _currentUserProfile = null;
  }

  Future<void> getCurrentUser() async {
    _loading = true;
    update();
    Response response = await repo.getCurrentUser();
    debugPrint("Get current user: ${response.statusCode}");

    if (response.statusCode == 200) {
      _currentUser = User.fromJson(response.body);
      if (_currentUser.username == "admin" &&
          _currentUser.email == "admin@globits.net") isAdmin = true;
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    update();
  }

  Future<void> restartListUser() async {
    isLastPage = false;
    currentPage = 1;
    _listUsers.clear();
    _usersPage.clear();
    _usersPageCurrent.clear();
    await getListUsersPage();
  }

  Future<void> getListUsersPage() async {
    _loading = true;
    update();

    Response response = await repo.getListUsersPage("", currentPage, 20, 0);
    debugPrint("List user page: ${response.statusCode}");

    if (response.statusCode == 200) {
      var responseData = response.body;
      if (responseData is Map<String, dynamic>) {
        PageableResponse convertPageableResponse =
            PageableResponse.fromJson(responseData);
        _usersPage = convertPageableResponse.content;
        _usersPageCurrent.addAll(_usersPage);
        Response response = await repo.getListUsersPage(
            "", 1, convertPageableResponse.totalElements, 0);
        debugPrint("List user: ${response.statusCode}");

        if (response.statusCode == 200) {
          var responseData = response.body;
          if (responseData is Map<String, dynamic>) {
            PageableResponse convertPageableResponse =
                PageableResponse.fromJson(responseData);
            _listUsers = convertPageableResponse.content;
            update();
          } else {
            throw Exception("Unexpected response format");
          }
        } else {
          ApiChecker.checkApi(response);
        }
      } else {
        throw Exception("Unexpected response format");
      }
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    update();
  }

  Future<int?> updateUserMySelf(User user) async {
    _loading = true;
    update();
    Response response = await repo.updateUserMySelf(user);
    debugPrint("updateUserMySelf: ${response.statusCode}");

    if (response.statusCode == 200) {
      _currentUser = User.fromJson(response.body);
      print(response.body);
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    update();
    return response.statusCode;
  }

  Future<int?> updateUserById(User user) async {
    _loading = true;
    update();

    Response response = await repo.updateUserById(user);
    debugPrint("updateUserById: ${response.statusCode}");
    if (response.statusCode == 200) {
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    update();
    return response.statusCode;
  }

  Future<User> getUserById(int id) async {
    _loading = true;
    update();
    Response response = await repo.getUserById(id);
    debugPrint("getUserById: ${response.statusCode}");

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      ApiChecker.checkApi(response);
    }

    _loading = false;
    update();
    return User.fromJson(response.body);
  }

  Future<int?> blockUser(int id) async {
    _loading = true;
    update();
    Response response = await repo.blockUser(id.toString());
    debugPrint("blockUser: ${response.statusCode}");

    if (response.statusCode == 200) {
    } else {
      ApiChecker.checkApi(response);
    }

    _loading = false;
    update();
    return response.statusCode;
  }

  Future<void> updateTokenDevice(String tokenDevice) async {
    _loading = true;
    update();
    Response response = await repo.updateTokenDevice(tokenDevice);
    debugPrint("updateTokenDevice: ${response.statusCode}");
    if (response.statusCode == 200) {
    } else {
      ApiChecker.checkApi(response);
    }

    _loading = false;
    update();
  }

  void deleteImage() {
    currentUser.image = null;
    update();
  }
}
