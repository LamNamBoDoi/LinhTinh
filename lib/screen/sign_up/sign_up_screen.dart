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
  final TextEditingController _universityTextController =
      TextEditingController();
  final TextEditingController _yearTextController = TextEditingController();

  final TextEditingController _confirmPasswordTextController =
      TextEditingController();

  final _valueGender = Rx<String?>(null);
  final _validateGender = true.obs;
  final _formKey = GlobalKey<FormState>();
  final _showPass = false.obs;
  final _showConfirmPass = false.obs;
  DateTime? _timeBirthday = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          title: Text("sign_up".tr),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HeaderWidget(context),
                      BodyWidget(context),
                    ],
                  ),
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
                  lable: 'last_name'.tr,
                  width: widthScreen / 2 - 20 - 10,
                  validator: (value) =>
                      value!.isEmpty ? 'please_enter_last_name'.tr : null,
                ),
                CustomTextField(
                  controller: _firstNameTextController,
                  lable: 'first_name'.tr,
                  width: widthScreen / 2 - 20 - 10,
                  validator: (value) =>
                      value!.isEmpty ? 'please_enter_first_name'.tr : null,
                ),
              ],
            ),
            CustomTextField(
              controller: _dateBirthDayTextController,
              width: widthScreen,
              lable: "birth_day".tr,
              enabled: true,
              validator: (value) =>
                  value!.isEmpty ? 'please_enter_birth_day'.tr : null,
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
              width: widthScreen,
              validator: (value) =>
                  value!.isEmpty ? 'please_enter_birth_place'.tr : null,
              lable: "birth_place".tr,
            ),
            SelectGenderWidget(
              valueGender: _valueGender,
              validateGender: _validateGender,
            ),
            CustomTextField(
              controller: _emailTextController,
              width: widthScreen,
              validator: (value) =>
                  value!.isEmpty ? 'please_enter_email'.tr : null,
              lable: "email".tr,
            ),
            CustomTextField(
              controller: _ussernameTextController,
              width: widthScreen,
              validator: (value) =>
                  value!.isEmpty ? 'please_enter_username'.tr : null,
              lable: "username".tr,
            ),
            CustomTextField(
              controller: _universityTextController,
              lable: "university".tr,
              validator: (value) =>
                  value!.isEmpty ? 'please_enter_university'.tr : null,
            ),
            CustomTextField(
              controller: _yearTextController,
              lable: "school_year".tr,
              validator: (value) =>
                  value!.isEmpty ? 'please_enter_year'.tr : null,
            ),
            Obx(
              () => CustomTextField(
                  controller: _paswordTextController,
                  lable: "password".tr,
                  isShowPass: _showPass.value,
                  validator: (value) =>
                      value!.isEmpty ? 'please_enter_password'.tr : null,
                  lastIcon: Icon(_showPass.value
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressedLastIcon: () => _showPass.value = !_showPass.value),
            ),
            Obx(
              () => CustomTextField(
                  controller: _confirmPasswordTextController,
                  lable: "confirm_password".tr,
                  validator: (value) => value!.isEmpty
                      ? 'please_enter_confirm_password'.tr
                      : null,
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
    if (!_formKey.currentState!.validate() ||
        _valueGender.value?.isEmpty == true) {
      showCustomSnackBar('cannot_left_blank'.tr);
      _validateGender.value = false;
      return;
    } else {
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
      String university = _universityTextController.text;
      int year = int.parse(_yearTextController.text);
      String? deviceToken = await FirebaseMessaging.instance.getToken();
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
        university: university,
        year: year,
      ))
          .then((value) {
        if (value == 200 || value == 201) {
          showCustomSnackBar('register_success'.tr, isError: false);
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
