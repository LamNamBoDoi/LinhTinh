import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/photo_controller.dart';
import 'package:timesheet/data/api/api_checker.dart';
import 'package:timesheet/data/model/body/users/pageable_response.dart';
import 'package:timesheet/data/model/body/users/user.dart';
import 'package:timesheet/data/repository/user_repo.dart';
import 'package:timesheet/view/custom_snackbar.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo repo;
  UserController({required this.repo});

  int currentPage = 1;
  bool isLastPage = false;
  bool _loading = false;
  bool isMyProfile = false;
  bool isAdmin = false;
  User _selectedUser = User();
  User get selectedUser => _selectedUser;
  set selectedUser(User user) {
    _selectedUser = user;
    update();
  }

  List<User> _listUsers = <User>[];
  List<User> _usersPage = <User>[];
  List<User> _usersPageCurrent = <User>[];
  List<User> _listFilteredUsers = <User>[];
  User _currentUser = User();
  User? _currentUserProfile;
  User _userUpdate = User();
  set userUpdate(User value) {
    _userUpdate = value;
    update();
  }

  User get userUpdate => _userUpdate;
  int _totalUser = 0;
  bool get loading => _loading;
  User get currentUser => _currentUser;
  User? get currentUserProfile => _currentUserProfile;
  String _image = "";
  set image(String value) {
    _image = value;
    update();
  }

  String get image => _image;
  List<User> get listUsers => _listUsers;
  List<User> get usersPage => _usersPage;
  List<User> get usersPageCurrent => _usersPageCurrent;
  List<User> get listFilteredUser => _listFilteredUsers;
  String query = "";
  Future<void> restartListUser() async {
    isLastPage = false;
    currentPage = 1;
    _image = "";
    _listUsers.clear();
    _usersPage.clear();
    _usersPageCurrent.clear();
    _listFilteredUsers.clear();
    query = "";
    await getListUsersPage(isUpdate: false);
    await getListUsers();
  }

  Future<void> getListUsers() async {
    PageableResponse? fullResponse = await _fetchUsers(1, _totalUser);
    if (fullResponse != null) {
      _listUsers = fullResponse.content;
      update();
    }
  }

  void searchUsers(String query) {
    this.query = query;
    if (query.isEmpty) {
      _listFilteredUsers.clear();
    } else {
      _listFilteredUsers = _listUsers
          .where((user) =>
              user.displayName?.toLowerCase().contains(query.toLowerCase()) ??
              false)
          .take(10)
          .toList();
    }
    update();
  }

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
      image = _currentUser.image ?? "";
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    update();
  }

  Future<void> getListUsersPage({required bool isUpdate}) async {
    _loading = true;
    update();
    int size = isUpdate ? currentPage * 20 : 20;
    int page = isUpdate ? 1 : currentPage;
    try {
      PageableResponse? pagedResponse = await _fetchUsers(page, size);
      if (pagedResponse != null) {
        _usersPage = pagedResponse.content;
        _usersPageCurrent.addAll(_usersPage);
        _totalUser = pagedResponse.totalElements;
      }
    } catch (e) {
      debugPrint("Error in getListUsersPage: $e");
    } finally {
      _loading = false;
      update();
    }
  }

  Future<PageableResponse?> _fetchUsers(int page, int size) async {
    Response response = await repo.getListUsersPage("", page, size, 0);
    debugPrint(
        "Fetching users - Page: $page, Size: $size, Status: ${response.statusCode}");

    if (response.statusCode == 200) {
      var responseData = response.body;
      if (responseData is Map<String, dynamic>) {
        return PageableResponse.fromJson(responseData);
      } else {
        throw Exception("Unexpected response format");
      }
    } else {
      ApiChecker.checkApi(response);
      return null;
    }
  }

  Future<int?> updateUserMySelf(User user) async {
    _loading = true;
    update();
    Response response = await repo.updateUserMySelf(user);
    debugPrint("updateUserMySelf: ${response.statusCode}");
    if (response.statusCode == 200) {
      _currentUser = User.fromJson(response.body);
      _userUpdate = _currentUser;
      showCustomFlash("update_profile_successfully".tr, Get.context!,
          isError: false);
    } else {
      showCustomFlash("update_profile_failed".tr, Get.context!, isError: true);
      ApiChecker.checkApi(response);
    }
    _loading = false;
    update();
    return response.statusCode;
  }

  Future<int?> updateUserById(User user) async {
    _loading = true;
    _usersPageCurrent.clear();
    update();
    Response response = await repo.updateUserById(user);
    debugPrint("updateUserById: ${response.statusCode}");
    print(response.body);
    if (response.statusCode == 200) {
      _selectedUser = User.fromJson(response.body);
      _image = _selectedUser.image ?? "";
      _userUpdate = _selectedUser;
      await getListUsersPage(isUpdate: true);
      await getListUsers();
      searchUsers(query);
      Get.find<PhotoController>().resetPickImage();
      showCustomFlash("update_profile_successfully".tr, Get.context!,
          isError: false);
    } else {
      showCustomFlash("update_profile_failed".tr, Get.context!, isError: true);
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
      _selectedUser = User.fromJson(response.body);
      _userUpdate = _selectedUser;
      print(_userUpdate.active);
      await getListUsersPage(isUpdate: true);
      await getListUsers();
      searchUsers(query);
      showCustomFlash("account_locked_successfully".tr, Get.context!,
          isError: false);
    } else {
      showCustomFlash("account_locked_failed".tr, Get.context!, isError: true);

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
    Get.find<PhotoController>().resetPickImage();
    _image = "";
    update();
  }
}
