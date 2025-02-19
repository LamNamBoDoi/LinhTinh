import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/controller/localization_controller.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/theme/theme_controller.dart';
import 'package:timesheet/utils/app_constants.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: height / 4,
            width: width,
            padding: EdgeInsets.all(20),
            child: GetBuilder<UserController>(
              builder: (controller) => Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color.fromRGBO(187, 222, 251, 1),
                    child: Icon(Icons.person, size: 50, color: Colors.blue),
                  ),
                  SizedBox(height: 10),
                  Text(controller.currentUser.displayName!,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                GetBuilder<ThemeController>(
                    builder: (controller) => ListTile(
                          leading: Icon(
                            Icons.dark_mode,
                            color: Colors.blue,
                          ),
                          title: Text("Chế độ tối màu"),
                          trailing: Switch(
                            value: controller.darkTheme!,
                            onChanged: (value) => controller.toggleTheme(),
                          ),
                        )),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: Colors.blue,
                  ),
                  title: Text("Thông báo"),
                ),
                Divider(),
                GetBuilder<LocalizationController>(builder: (controller) {
                  String languageName = AppConstants.languages
                      .map((lang) =>
                          lang.languageCode == controller.locale.languageCode
                              ? lang.languageName
                              : null)
                      .firstWhere((name) => name != null,
                          orElse: () => "Unknown")!;

                  return ListTile(
                    leading: Icon(
                      Icons.language,
                      color: Colors.blue,
                    ),
                    title: Text("Ngôn ngữ"),
                    trailing: Text(languageName),
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          color: Colors.white,
                          child: Wrap(
                            children: [
                              ListTile(
                                title: Text("Tiếng Việt"),
                                onTap: () {
                                  controller.setLanguage(Locale('vi', 'VN'));
                                  Get.back();
                                },
                              ),
                              ListTile(
                                title: Text("English"),
                                onTap: () {
                                  controller.setLanguage(Locale('en', 'US'));
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
                Divider(),
                GetBuilder<AuthController>(builder: (controller) {
                  return ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.blue,
                    ),
                    title: Text("Đăng xuất"),
                  );
                }),
                Divider(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
