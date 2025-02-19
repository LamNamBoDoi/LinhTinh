import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/screen/home/home_screen.dart';
import 'package:timesheet/screen/sign_up/sign_up_screen.dart';
import 'package:timesheet/utils/color_resources.dart';
import 'package:timesheet/utils/dimensions.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/custom_button.dart';
import 'package:timesheet/view/custom_snackbar.dart';
import 'package:timesheet/view/custom_text_field.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _showPass = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HeaderWidget(),
                BodyWidget(context),
              ],
            ),
          ),
          Center(
            child: GetBuilder<AuthController>(
              builder: (controller) => Visibility(
                  visible: controller.loading,
                  child: const CircularProgressIndicator()),
            ),
          )
        ],
      ),
    ));
  }

  Widget HeaderWidget() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(30),
          child: Center(
            child: Image.asset(
              Images.logonew,
              height: 120,
              width: 120,
            ),
          ),
        ),
        Container(
          child: Text(
            'sign_in'.tr,
            style: TextStyle(
              fontSize: Dimensions.fontSizeOverLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget BodyWidget(context) {
    return GetBuilder<AuthController>(
        builder: (controller) => Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  CustomTextField(
                    controller: _usernameController,
                    lable: 'username'.tr,
                    textInputAction: TextInputAction.next,
                    icon: const Icon(Icons.person),
                    padding: const EdgeInsets.only(top: 10),
                  ),
                  Obx(
                    () => CustomTextField(
                        lable: "password".tr,
                        textInputAction: TextInputAction.done,
                        controller: _passwordController,
                        padding: const EdgeInsets.only(top: 10),
                        isShowPass: _showPass.value,
                        icon: const Icon(Icons.lock),
                        lastIcon: Icon(_showPass.value
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressedLastIcon: () =>
                            _showPass.value = !_showPass.value),
                  ),
                  CustomButton(
                    width: double.infinity,
                    buttonText: "login".tr,
                    margin: EdgeInsets.only(top: 30),
                    onPressed: _login,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: RichText(
                      text: TextSpan(style: TextStyle(fontSize: 14), children: [
                        TextSpan(
                            text: "don't_have_an_account? ".tr,
                            style: const TextStyle(color: Colors.black)),
                        TextSpan(
                            text: "sign_up".tr,
                            style: TextStyle(
                                color: ColorResources.COLOR_PRIMARY,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(SignUpScreen(),
                                    transition: Transition.rightToLeft,
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeIn);
                              })
                      ]),
                    ),
                  )
                ],
              ),
            ));
  }

  _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;
    if (username.isEmpty || password.isEmpty) {
      showCustomSnackBar("you_need_enter_your_acount".tr);
    } else {
      Get.find<AuthController>().login(username, password).then((value) {
        if (value == 200) {
          Get.offAll(HomeScreen(),
              transition: Transition.cupertinoDialog,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn);
        } else if (value == 400) {
          showCustomSnackBar("account_password_is_incorrect".tr);
        } else {
          showCustomSnackBar("please_try_again".tr);
        }
        Get.find<UserController>().getCurrentUser();
      });
    }
  }
}
