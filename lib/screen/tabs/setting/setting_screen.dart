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

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "settings".tr,
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
                                            secondary: const Icon(
                                                Icons.dark_mode,
                                                color: Colors.blue),
                                            title: Text("dark_color_mode".tr),
                                            value: themeController.darkTheme!,
                                            onChanged: (_) {
                                              themeController.toggleTheme();
                                              themeController.darkTheme == true
                                                  ? showCustomFlash(
                                                      "dark_mode".tr, context,
                                                      isError: false)
                                                  : showCustomFlash(
                                                      "bright_mode".tr, context,
                                                      isError: false);
                                            });
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
                                            onTap: () {
                                              userController.image =
                                                  userController
                                                      .currentUser.image!;
                                              userController.userUpdate =
                                                  userController.currentUser;
                                              Get.to(() => EditProfileScreen(
                                                    isMyProfile: true,
                                                  ));
                                            });
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
              backgroundImage: (controller.currentUser.image != "" &&
                      controller.currentUser.image != null)
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
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppConstants.languages.map((lang) {
            final isCurrentLanguage =
                controller.locale.languageCode == lang.languageCode;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: isCurrentLanguage ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: isCurrentLanguage
                    ? Icon(Icons.check_circle,
                        color: Theme.of(context).primaryColor)
                    : const SizedBox(),
                title: Text(
                  lang.languageName,
                  style: TextStyle(
                    color: isCurrentLanguage ? Colors.white : Colors.black,
                    fontWeight:
                        isCurrentLanguage ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                onTap: () {
                  if (!isCurrentLanguage) {
                    controller.setLanguage(
                        Locale(lang.languageCode, lang.countryCode));
                    showCustomFlash("changed_language".tr, context,
                        isError: false);
                  }
                  Get.back();
                },
              ),
            );
          }).toList(),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  void _handleLogout(AuthController authController) {
    authController.logOut().then((response) {
      if (response == 200) {
        showCustomFlash("Đăng xuất thành công".tr, Get.context!,
            isError: false);
        Get.find<UserController>().resetDataProfile();
        Get.offAll(() => SignInScreen());
      } else {
        showCustomFlash("Đăng xuất thất bại".tr, Get.context!, isError: true);
      }
    });
  }
}
