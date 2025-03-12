import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/controller/localization_controller.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/screen/sign_in/sign_in_screen.dart';
import 'package:timesheet/screen/tabs/setting/edit_profile_screen.dart';
import 'package:timesheet/screen/tabs/setting/notify_screen.dart';
import 'package:timesheet/screen/tabs/setting/widget/setting_item.dart';
import 'package:timesheet/theme/theme_controller.dart';
import 'package:timesheet/utils/app_constants.dart';
import 'package:timesheet/view/custom_snackbar.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Setting",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          elevation: 0,
        ),
        body: GetBuilder<UserController>(
          initState: (_) async =>
              await Get.find<UserController>().getCurrentUser(),
          builder: (userController) => Stack(
            children: [
              Column(
                children: [
                  _buildProfileSection(),
                  Divider(
                      thickness: 1,
                      height: 1,
                      color: Theme.of(context).dividerColor),
                  Expanded(
                    child: GetBuilder<ThemeController>(
                      builder: (themeController) {
                        return GetBuilder<LocalizationController>(
                          builder: (localizationController) {
                            return GetBuilder<AuthController>(
                              builder: (authController) {
                                return ListView.separated(
                                  itemCount: 6,
                                  separatorBuilder: (_, __) => Divider(
                                      thickness: 1,
                                      height: 1,
                                      color: Theme.of(context).dividerColor),
                                  itemBuilder: (context, index) {
                                    switch (index) {
                                      case 0:
                                        return SwitchListTile(
                                          secondary: const Icon(Icons.dark_mode,
                                              color: Colors.blue),
                                          title: Text("dark_color_mode".tr),
                                          value: themeController.darkTheme!,
                                          onChanged: (_) =>
                                              themeController.toggleTheme(),
                                        );
                                      case 1:
                                        return SettingItem(
                                          icon: Icons.notifications,
                                          title: "notification".tr,
                                          onTap: () => Get.to(
                                              () => const NotifyScreen()),
                                        );
                                      case 2:
                                        return SettingItem(
                                          icon: Icons.person,
                                          title: "personal_information".tr,
                                          onTap: () => Get.to(() =>
                                              EditProfileScreen(
                                                  user:
                                                      Get.find<UserController>()
                                                          .currentUser)),
                                        );
                                      case 3:
                                        String languageName = AppConstants
                                            .languages
                                            .firstWhere(
                                              (lang) =>
                                                  lang.languageCode ==
                                                  localizationController
                                                      .locale.languageCode,
                                              orElse: () =>
                                                  AppConstants.languages.first,
                                            )
                                            .languageName;

                                        return SettingItem(
                                          icon: Icons.language,
                                          title: "language".tr,
                                          trailing: Text(languageName,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          onTap: () => _showLanguageBottomSheet(
                                              localizationController),
                                        );
                                      case 4:
                                        return SettingItem(
                                          icon: Icons.logout,
                                          title: "sign_out".tr,
                                          onTap: () =>
                                              _handleLogout(authController),
                                        );
                                      default:
                                        return const SizedBox();
                                    }
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              if (userController.loading == true)
                const Center(
                  child: CircularProgressIndicator(),
                )
            ],
          ),
        ));
  }

  Widget _buildProfileSection() {
    return GetBuilder<UserController>(
      builder: (controller) => Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: controller.currentUser.image != null
                  ? NetworkImage(controller.currentUser
                      .getLinkImageUrl(controller.currentUser.image!))
                  : const AssetImage("assets/image/avatarDefault.jpg")
                      as ImageProvider,
            ),
            const SizedBox(height: 10),
            Text(
              controller.currentUser.displayName ?? "",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(LocalizationController controller) {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppConstants.languages.map((lang) {
            return ListTile(
              title: Text(lang.languageName,
                  style: const TextStyle(color: Colors.black)),
              onTap: () {
                controller
                    .setLanguage(Locale(lang.languageCode, lang.countryCode));
                Get.back();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _handleLogout(AuthController authController) {
    authController.logOut().then((response) {
      if (response == 200) {
        showCustomFlash("Đăng xuất thành công", Get.context!, isError: false);
        Get.find<UserController>().resetDataProfile();
        Get.offAll(() => SignInScreen());
      } else {
        showCustomFlash("Đăng xuất thất bại", Get.context!, isError: true);
      }
    });
  }
}
