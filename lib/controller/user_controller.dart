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
  User _currentUser = User();
  User? _currentUserProfile;

  bool get loading => _loading;
  User get currentUser => _currentUser;
  User? get currentUserProfile => _currentUserProfile;
  List<User> get listUsers => _listUsers;
  List<User> get usersPage => _usersPage;

  void resetDataProfile() {
    isAdmin = false;
    isMyProfile = false;
    _currentUserProfile = null;
  }

  Future<void> getCurrentUser() async {
    Response response = await repo.getCurrentUser();
    print(response.body);
    if (response.statusCode == 200) {
      _currentUser = User.fromJson(response.body);
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> restartListUser() {
    isLastPage = false;
    currentPage = 1;
    update();
    return getListUsersPage();
  }

  Future<void> getListUsersPage() async {
    _loading = true;
    update();

    Response response = await repo.getListUsersPage("", currentPage, 10, 0);
    debugPrint("List user page: ${response.statusCode}");

    if (response.statusCode == 200) {
      var responseData = response.body;
      if (responseData is Map<String, dynamic>) {
        PageableResponse convertPageableResponse =
            PageableResponse.fromJson(responseData);
        _usersPage = convertPageableResponse.content;
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

  void deleteImage() {
    currentUser.image = null;
    update();
  }
}
