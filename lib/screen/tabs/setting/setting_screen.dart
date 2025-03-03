import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/controller/localization_controller.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/screen/sign_in/sign_in_screen.dart';
import 'package:timesheet/screen/tabs/setting/edit_profile_screen.dart';
import 'package:timesheet/screen/tabs/setting/notify_screen.dart';
import 'package:timesheet/theme/theme_controller.dart';
import 'package:timesheet/utils/app_constants.dart';
import 'package:timesheet/view/custom_snackbar.dart';

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
                    backgroundImage: controller.currentUser.image != null
                        ? NetworkImage(controller.currentUser
                            .getLinkImageUrl(controller.currentUser.image!))
                        : AssetImage("assets/image/avatarDefault.jpg")
                            as ImageProvider,
                  ),
                  SizedBox(height: 10),
                  Text(controller.currentUser.displayName!,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge!.color)),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Divider(
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                GetBuilder<ThemeController>(
                    builder: (controller) => ListTile(
                          leading: const Icon(
                            Icons.dark_mode,
                            color: Colors.blue,
                          ),
                          title: Text("dark_color_mode".tr),
                          trailing: Switch(
                            value: controller.darkTheme!,
                            onChanged: (value) => controller.toggleTheme(),
                          ),
                        )),
                Divider(
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: Colors.blue,
                  ),
                  title: Text("notification".tr),
                  onTap: () => Get.to(() => NotifyScreen()),
                ),
                Divider(
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  title: Text("personal_information".tr),
                  onTap: () {
                    Get.to(() => EditProfileScreen(
                          user: Get.find<UserController>().currentUser,
                        ));
                  },
                ),
                Divider(
                  color: Theme.of(context).secondaryHeaderColor,
                ),
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
                    title: Text("language".tr),
                    trailing: Text(languageName),
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          color: Colors.white,
                          child: Wrap(
                            children: [
                              ListTile(
                                title: Text(
                                  "Tiếng Việt",
                                  style: TextStyle(color: Colors.black),
                                ),
                                onTap: () {
                                  controller.setLanguage(Locale('vi', 'VN'));
                                  Get.back();
                                },
                              ),
                              ListTile(
                                title: Text(
                                  "English",
                                  style: TextStyle(color: Colors.black),
                                ),
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
                Divider(
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                GetBuilder<AuthController>(builder: (controller) {
                  return ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.blue,
                    ),
                    title: Text("sign_out".tr),
                    onTap: () => controller.logOut().then((response) {
                      if (response == 200) {
                        showCustomFlash("Đăng xuất thành công", context,
                            isError: false);
                        Get.find<UserController>().resetDataProfile();
                        Get.offAll(() => SignInScreen());
                      } else {
                        showCustomFlash("Đăng xuất thất bại", context,
                            isError: true);
                      }
                    }),
                  );
                }),
                Divider(
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
