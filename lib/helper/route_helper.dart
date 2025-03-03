import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:timesheet/screen/sign_in/sign_in_screen.dart';
import 'package:timesheet/screen/sign_up/sign_up_screen.dart';
import 'package:timesheet/screen/tabs/posting/create_post_screen.dart';
import 'package:timesheet/screen/tabs/time_sheet/time_sheet_screen.dart';
import 'package:timesheet/screen/tabs/tracking/tracking_screen.dart';
import '../screen/home/home_screen.dart';
import '../screen/splash/splash_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String language = '/language';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String home = '/home';
  static const String tracking = '/tracking';
  static const String timesheet = '/timesheet';
  static const String createpost = '/createpost';

  static String getInitialRoute() => initial;

  static String getSplashRoute() => splash;

  static String getLanguageRoute(String page) => '$language?page=$page';

  static String getSignInRoute() => signIn;

  static String getSignUpRoute() => signUp;
  static String getTrackingRoute() => tracking;
  static String getTimesheetRoute() => timesheet;
  static String getCreatePostRoute() => createpost;

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: signIn, page: () => SignInScreen()),
    GetPage(name: signUp, page: () => SignUpScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: initial, page: () => HomeScreen()),
    GetPage(name: tracking, page: () => TrackingScreen()),
    GetPage(name: timesheet, page: () => TimeSheetScreen()),
    GetPage(name: createpost, page: () => CreatePostScreen())
  ];

  static getRoute(Widget navigateTo) {
    // int _minimumVersion = 0;
    // if (GetPlatform.isAndroid) {
    //   _minimumVersion =
    //       Get.find<SplashController>().configModel.appMinimumVersionAndroid;
    // } else if (GetPlatform.isIOS) {
    //   _minimumVersion =
    //       Get.find<SplashController>().configModel.appMinimumVersionIos;
    // }
    // return AppConstants.APP_VERSION < _minimumVersion
    //     ? UpdateScreen(isUpdate: true)
    //     : Get.find<SplashController>().configModel.maintenanceMode
    //         ? UpdateScreen(isUpdate: false)
    //         : Get.find<LocationController>().getUserAddress() == null
    //             ? AccessLocationScreen(
    //                 fromSignUp: false, fromHome: false, route: Get.currentRoute)
    //             :
    navigateTo;
  }
}
