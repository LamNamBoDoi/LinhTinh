import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/data/model/body/users/role.dart';
import 'package:timesheet/data/model/body/users/user.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/screen/sign_in/sign_in_screen.dart';
import 'package:timesheet/screen/tabs/setting/widget/select_gender_widget.dart';
import 'package:timesheet/utils/dimensions.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/custom_button.dart';
import 'package:timesheet/view/custom_snackbar.dart';
import 'package:timesheet/view/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController _lastNameTextController = TextEditingController();

  final TextEditingController _firstNameTextController =
      TextEditingController();

  final TextEditingController _dateBirthDayTextController =
      TextEditingController();

  final TextEditingController _birthPlaceTextController =
      TextEditingController();

  final TextEditingController _emailTextController = TextEditingController();

  final TextEditingController _ussernameTextController =
      TextEditingController();

  final TextEditingController _paswordTextController = TextEditingController();

  final TextEditingController _confirmPasswordTextController =
      TextEditingController();

  final _valueGender = Rx<String?>(null);

  final _showPass = false.obs;
  final _showConfirmPass = false.obs;
  DateTime? _timeBirthday = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(),
        body: SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HeaderWidget(context),
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

  Widget HeaderWidget(BuildContext context) {
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
            'register'.tr,
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
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

  Widget BodyWidget(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return GetBuilder<AuthController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                CustomTextField(
                  controller: _lastNameTextController,
                  padding: EdgeInsets.all(10),
                  lable: 'last_name'.tr,
                  width: widthScreen / 2 - 20 - 10,
                ),
                CustomTextField(
                  controller: _firstNameTextController,
                  padding: EdgeInsets.all(10),
                  lable: 'first_name'.tr,
                  width: widthScreen / 2 - 20 - 10,
                ),
              ],
            ),
            CustomTextField(
              controller: _dateBirthDayTextController,
              padding: EdgeInsets.all(10),
              width: widthScreen,
              lable: "birth_day".tr,
              enabled: true,
              lastIcon: Icon(Icons.calendar_month),
              onPressedLastIcon: () async {
                final DateTime? dateTime = await showRoundedDatePicker(
                  context: context,
                  fontFamily: 'NotoSerif',
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2026),
                  locale: Locale('en', 'US'),
                  borderRadius: 16,
                  height: 250,
                  imageHeader: AssetImage(Images.bgDate),
                  styleDatePicker: MaterialRoundedDatePickerStyle(
                    textStyleDayHeader: TextStyle(color: Colors.amber),
                  ),
                  initialDate: DateTime.now(),
                );
                _dateBirthDayTextController.text =
                    DateConverter.dateTimeStringToDateOnly(dateTime.toString());
                _timeBirthday = dateTime;
              },
            ),
            CustomTextField(
              controller: _birthPlaceTextController,
              padding: EdgeInsets.all(10),
              width: widthScreen,
              lable: "birth_place".tr,
            ),
            SelectGenderWidget(valueGender: _valueGender),
            CustomTextField(
              controller: _emailTextController,
              padding: EdgeInsets.all(10),
              width: widthScreen,
              lable: "email".tr,
            ),
            CustomTextField(
              controller: _ussernameTextController,
              padding: EdgeInsets.all(10),
              width: widthScreen,
              lable: "username".tr,
            ),
            Obx(
              () => CustomTextField(
                  controller: _paswordTextController,
                  lable: "password".tr,
                  padding: EdgeInsets.all(10),
                  isShowPass: _showPass.value,
                  lastIcon: Icon(_showPass.value
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressedLastIcon: () => _showPass.value = !_showPass.value),
            ),
            Obx(
              () => CustomTextField(
                  controller: _confirmPasswordTextController,
                  lable: "confirm_password".tr,
                  padding: EdgeInsets.all(10),
                  isShowPass: _showConfirmPass.value,
                  lastIcon: Icon(_showConfirmPass.value
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressedLastIcon: () =>
                      _showConfirmPass.value = !_showConfirmPass.value),
            ),
            CustomButton(
              width: double.infinity,
              buttonText: "sign_up".tr,
              margin: const EdgeInsets.all(10),
              onPressed: _signup,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: RichText(
                text: TextSpan(style: TextStyle(fontSize: 14), children: [
                  TextSpan(
                      text: "don't_have_an_account? ".tr,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color)),
                  TextSpan(
                      text: "sign_in".tr,
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(SignInScreen(),
                              transition: Transition.rightToLeft,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeIn);
                        })
                ]),
              ),
            ),
            SizedBox(
              height: 35,
            ),
          ],
        ),
      ),
    );
  }

  _signup() async {
    String lastName = _lastNameTextController.text;
    String firstName = _firstNameTextController.text;
    String? dateBirthDay =
        _timeBirthday != null ? _timeBirthday!.toIso8601String() + "Z" : null;
    String? birthPlace = _birthPlaceTextController.text;
    String? gender = _valueGender.value;
    String email = _emailTextController.text;
    String ussername = _ussernameTextController.text;
    String password = _paswordTextController.text;
    String confirmPassword = _confirmPasswordTextController.text;
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    if (lastName.isEmpty ||
        birthPlace.isEmpty ||
        firstName.isEmpty ||
        gender!.isEmpty ||
        email.isEmpty ||
        ussername.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showCustomSnackBar('cannot_left_blank'.tr);
    } else {
      Get.find<AuthController>()
          .signup(User(
        id: null,
        username: ussername,
        active: true,
        birthPlace: birthPlace,
        confirmPassword: confirmPassword,
        displayName: "$lastName $firstName",
        dob: dateBirthDay,
        email: email,
        firstName: firstName,
        lastName: lastName,
        password: password,
        changePass: true,
        setPassword: true,
        roles: <Role>[],
        countDayCheckin: 0,
        countDayTracking: 0,
        gender: gender,
        hasPhoto: false,
        tokenDevice: deviceToken,
        university: null,
        year: 0,
      ))
          .then((value) {
        if (value == 200 || value == 201) {
          showCustomSnackBar('register_success'.tr);
          Get.offAll(SignInScreen(),
              transition: Transition.cupertinoDialog,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn);
        } else if (value == 400) {
          showCustomSnackBar('infomation_incorect'.tr);
        } else {
          showCustomSnackBar('please_try_again'.tr);
        }
      });
    }
  }
}
