import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/firebase_options.dart';
import 'package:timesheet/helper/notification_helper.dart';
import 'package:timesheet/theme/dark_theme.dart';
import 'package:timesheet/theme/light_theme.dart';
import 'package:timesheet/theme/theme_controller.dart';
import 'package:timesheet/utils/app_constants.dart';
import 'package:timesheet/utils/messages.dart';
import 'controller/localization_controller.dart';
import 'helper/get_di.dart' as di;
import 'helper/responsive_helper.dart';
import 'helper/route_helper.dart';

Future<void> main() async {
  if (kDebugMode) {
    print("Bắt đầu: ${DateTime.now()}");
  }
  WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized(); // khởi tạo
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  if (ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = MyHttpOverrides();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    if (GetPlatform.isMobile) {
      await NotificationHelper.requestNotificationPermission(); // Yêu cầu quyền
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  } catch (e) {
    print('Lỗi khi khởi tạo thông báo: $e');
  }

  Map<String, Map<String, String>> _languages = await di.init();
// Kiểm tra đăng nhập
  bool isLoggedIn = await checkLoginStatus();
  String initialRoute = isLoggedIn ? RouteHelper.home : RouteHelper.signIn;
  runApp(MyApp(languages: _languages, initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>>? languages;
  final String initialRoute;

  const MyApp({super.key, this.languages, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        FlutterNativeSplash.remove();
        print("Kết thúc init: ${DateTime.now()}");
        return GetMaterialApp(
          title: AppConstants.APP_NAME,
          debugShowCheckedModeBanner: false,
          navigatorKey: Get.key,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
          ),
          theme: themeController.darkTheme!
              ? themeController.darkColor == null
                  ? dark()
                  : dark(color: themeController.darkColor!)
              : themeController.lightColor == null
                  ? light()
                  : light(color: themeController.lightColor!),
          locale: localizeController.locale,
          translations: Messages(languages: languages),
          fallbackLocale: Locale(AppConstants.languages[0].languageCode,
              AppConstants.languages[0].countryCode),
          // initialRoute: GetPlatform.isWeb
          //     ? RouteHelper.getInitialRoute()
          //     : RouteHelper.getSplashRoute(),
          initialRoute: initialRoute,

          getPages: RouteHelper.routes,
          defaultTransition: Transition.topLevel,
          transitionDuration: const Duration(milliseconds: 250),
        );
      });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<bool> checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString(AppConstants.TOKEN);

  if (token == null) {
    return false;
  }

  try {
    int response = await Get.find<AuthController>().getToken();
    await Get.find<UserController>().getCurrentUser();

    if (response == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print('Lỗi khi kiểm tra đăng nhập: $e');
    return false;
  }
}
