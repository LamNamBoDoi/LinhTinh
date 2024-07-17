import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import '../../controller/splash_controller.dart';
import '../../helper/route_helper.dart';
import '../../utils/dimensions.dart';
import '../../utils/images.dart';
import '../../view/no_internet_screen.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();
    bool firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? const SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection'.tr : 'connected'.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });
    _route();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SplashController>(builder: (splashController) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Center(
            child: splashController.hasConnection
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(Images.logo, width: 200),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    ],
                  )
                : NoInternetScreen(child: const SplashScreen()),
          ),
        );
      }),
    );
  }

  _route() {
    Get.find<AuthController>().getCurrentUser().then((value) => {
          if (value == 200)
            {
              Get.to(const HomeScreen(),)
            }
          else
            {Get.offNamed(RouteHelper.signIn)}
        });
  }
}
