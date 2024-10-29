import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/data/model/body/role.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/utils/dimensions.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/custom_button.dart';
import 'package:timesheet/view/custom_snackbar.dart';
import 'package:timesheet/view/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
            'register'.tr,
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
              enabled: false,
              lastIcon: Icon(Icons.calendar_month),
              onPressedLastIcon: () async {
                final DateTime? dateTime = await showRoundedDatePicker(
                  context: context,
                  fontFamily: 'NotoSerif',
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2025),
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
              },
            ),
            CustomTextField(
              controller: _birthPlaceTextController,
              padding: EdgeInsets.all(10),
              width: widthScreen,
              lable: "birth_place".tr,
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Text('select_your_gender'.tr),
                    value: _valueGender.value,
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 36,
                    ),
                    underline: SizedBox(),
                    items: []
                      ..add(
                        DropdownMenuItem(
                          value: "m",
                          child: Text("male".tr),
                        ),
                      )
                      ..add(
                        DropdownMenuItem(
                          value: "n",
                          child: Text("female".tr),
                        ),
                      )
                      ..add(
                        DropdownMenuItem(
                          value: "o",
                          child: Text("other".tr),
                        ),
                      ),
                    onChanged: (value) {
                      _valueGender.value = value.toString(); // Cập nhật giá trị
                    },
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
                  isShowPass: _showPass.value,
                  lastIcon: Icon(_showPass.value
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressedLastIcon: () => _showPass.value = !_showPass.value),
            ),
            CustomButton(
              width: double.infinity,
              buttonText: "sign_up".tr,
              margin: const EdgeInsets.all(10),
              onPressed: _login,
            ),
            SizedBox(
              height: 35,
            )
          ],
        ),
      ),
    );
  }

  _login() {
    String lastName = _lastNameTextController.text;
    String firstName = _firstNameTextController.text;
    String? dateBirthDay = _dateBirthDayTextController.text;
    String? birthPlace = _birthPlaceTextController.text;
    String? gender = _valueGender.value;
    String email = _emailTextController.text;
    String ussername = _ussernameTextController.text;
    String password = _paswordTextController.text;
    String confirmPassword = _confirmPasswordTextController.text;

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
          .signin(User(
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
        tokenDevice: "",
        university: null,
        year: 0,
      ))
          .then((value) {
        if (value == 200 || value == 201) {
          showCustomSnackBar('register_success'.tr);
          //Get.back();
        } else if (value == 400) {
          showCustomSnackBar('infomation_incorect'.tr);
        } else {
          showCustomSnackBar('please_try_again'.tr);
        }
      });
    }
  }
}
