import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/screen/tabs/posting/posting_screen.dart';
import 'package:timesheet/screen/tabs/setting/setting_screen.dart';
import 'package:timesheet/screen/tabs/time_sheet/time_sheet_screen.dart';
import 'package:timesheet/screen/tabs/tracking/tracking_screen.dart';
import 'package:timesheet/screen/tabs/users/users_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _selectedIndex = 0.obs;
  final UserController userController = Get.find<UserController>();
  final List<Widget> _pagesUser = [
    TimeSheetScreen(),
    TrackingScreen(),
    UsersScreen(),
    PostingScreen(),
    SettingScreen(),
  ];

  final List<Widget> _adminPages = [
    UsersScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Obx(() {
          return userController.isAdmin
              ? _adminPages[_selectedIndex.value] // Admin chỉ thấy Setting
              : _pagesUser[_selectedIndex.value]; // User thấy toàn bộ
        }),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: userController.isAdmin == false
                  ? <Widget>[
                      Obx(() => IconButton(
                            icon: Icon(
                              Icons.check,
                              color: _selectedIndex.value == 0
                                  ? Theme.of(context).secondaryHeaderColor
                                  : Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () => _selectedIndex.value = 0,
                          )),
                      Obx(() => IconButton(
                            icon: Icon(
                              Icons.track_changes,
                              color: _selectedIndex.value == 1
                                  ? Colors.green
                                  : Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () => _selectedIndex.value = 1,
                          )),
                      Obx(() => IconButton(
                            icon: Icon(
                              Icons.people,
                              color: _selectedIndex.value == 2
                                  ? Colors.green
                                  : Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () => _selectedIndex.value = 2,
                          )),
                      Obx(() => IconButton(
                            icon: Icon(
                              Icons.post_add,
                              color: _selectedIndex.value == 3
                                  ? Colors.green
                                  : Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () => _selectedIndex.value = 3,
                          )),
                      Obx(() => IconButton(
                            icon: Icon(
                              Icons.school,
                              color: _selectedIndex.value == 4
                                  ? Colors.green
                                  : Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () => _selectedIndex.value = 4,
                          )),
                    ]
                  : [
                      Obx(() => IconButton(
                            icon: Icon(
                              Icons.people,
                              color: _selectedIndex.value == 0
                                  ? Colors.green
                                  : Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () => _selectedIndex.value = 0,
                          )),
                      Obx(() => IconButton(
                            icon: Icon(
                              Icons.school,
                              color: _selectedIndex.value == 1
                                  ? Colors.green
                                  : Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () => _selectedIndex.value = 1,
                          )),
                    ]),
        ),
      ),
    );
  }
}
