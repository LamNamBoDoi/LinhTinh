import 'package:flutter/foundation.dart';
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

  List<User> _users = <User>[];
  List<User> _usersPage = <User>[];
  User _currentUser = User();
  User? _currentUserProfile;

  bool get loading => _loading;
  User get currentUser => _currentUser;
  User? get currentUserProfile => _currentUserProfile;
  List<User> get users => _users;
  List<User> get usersPage => _usersPage;

  void resetDataProfile() {
    isAdmin = false;
    isMyProfile = false;
    _currentUserProfile = null;
  }

  Future<void> getCurrentUser() async {
    Response response = await repo.getCurrentUser();

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

    Response response =
        await repo.getListUsersPage("Thien12", currentPage, 10, 0);
    debugPrint("okeoke: ${response.statusCode}");
    if (response.statusCode == 200) {
      var responseData = response.body;
      if (responseData is Map<String, dynamic>) {
        PageableResponse convertPageableResponse =
            PageableResponse.fromJson(responseData);
        _usersPage = convertPageableResponse.content;
      } else {
        throw Exception("Unexpected response format");
      }
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    update();
  }
}
