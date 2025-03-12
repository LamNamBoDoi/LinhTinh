import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/photo_controller.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/data/model/body/users/user.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/screen/tabs/setting/widget/change_avatar_widget.dart';
import 'package:timesheet/screen/tabs/setting/widget/select_gender_widget.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/custom_button.dart';
import 'package:timesheet/view/custom_snackbar.dart';
import 'package:timesheet/view/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
  final User user;
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _displayNameTextController =
      TextEditingController();
  final TextEditingController _dateBirthDayTextController =
      TextEditingController();
  final TextEditingController _birthPlaceTextController =
      TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _universityTextController =
      TextEditingController();
  final TextEditingController _yearTextController = TextEditingController();
  final _valueGender = Rx<String?>("");

  DateTime? _timeBirthday = null;
  RxBool _activeUser = true.obs;
  @override
  void initState() {
    super.initState();
    PhotoController photoController = Get.find<PhotoController>();
    photoController.selectedPhoto = null;
    _activeUser = RxBool(widget.user.active ?? true);
    _displayNameTextController.text = widget.user.displayName ?? "";
    _dateBirthDayTextController.text = widget.user.dob ?? "";
    _birthPlaceTextController.text = widget.user.birthPlace ?? "";
    _emailTextController.text = widget.user.email ?? "";
    _usernameTextController.text = widget.user.username ?? "";
    _universityTextController.text = widget.user.university ?? "";
    _yearTextController.text = widget.user.year.toString() ?? "";
    _valueGender.value = widget.user.gender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("edit_profile".tr),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ChangeAvatarWidget(user: widget.user),
                SizedBox(height: 20),
                Obx(
                  () => SwitchListTile(
                    title: Text("account_status".tr,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color)),
                    value: _activeUser.value,
                    onChanged: (value) {
                      if (_activeUser.value == true)
                        showCustomConfirm(context, "change_account_status".tr,
                            () {
                          _activeUser.value = value;
                          Get.find<UserController>()
                              .blockUser(widget.user.id!)
                              .then((response) async {
                            if (response == 200) {
                              showCustomSnackBar("success".tr, isError: false);
                            } else {
                              showCustomSnackBar("fail".tr, isError: true);
                            }
                            Navigator.pop(context);
                            await Get.find<UserController>().getListUsersPage();
                          });
                        });
                    },
                  ),
                ),
                CustomTextField(
                  controller: _displayNameTextController,
                  padding: EdgeInsets.all(10),
                  lable: 'last_name'.tr,
                ),
                CustomTextField(
                  controller: _dateBirthDayTextController,
                  padding: EdgeInsets.all(10),
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
                        DateConverter.dateTimeStringToDateOnly(
                            dateTime.toString());
                    _timeBirthday = dateTime;
                  },
                ),
                CustomTextField(
                  controller: _birthPlaceTextController,
                  padding: EdgeInsets.all(10),
                  lable: "birth_place".tr,
                ),
                SelectGenderWidget(valueGender: _valueGender),
                CustomTextField(
                  controller: _emailTextController,
                  padding: EdgeInsets.all(10),
                  lable: "email".tr,
                ),
                CustomTextField(
                  controller: _usernameTextController,
                  padding: EdgeInsets.all(10),
                  lable: "username".tr,
                ),
                CustomTextField(
                  controller: _universityTextController,
                  padding: EdgeInsets.all(10),
                  lable: "University".tr,
                ),
                CustomTextField(
                  controller: _yearTextController,
                  padding: EdgeInsets.all(10),
                  lable: "Year".tr,
                ),
                CustomButton(
                  width: double.infinity,
                  buttonText: "update".tr,
                  margin: const EdgeInsets.all(10),
                  onPressed: _updateProfile,
                ),
              ],
            ),
          ),
          if (Get.find<UserController>().loading == true)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  void _updateProfile() async {
    UserController userController = Get.find<UserController>();
    PhotoController photoController = Get.find<PhotoController>();
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    String? dateBirthDay =
        _timeBirthday != null ? _timeBirthday!.toIso8601String() + "Z" : null;
    if (_displayNameTextController.text.isEmpty ||
        _birthPlaceTextController.text.isEmpty ||
        _emailTextController.text.isEmpty ||
        _usernameTextController.text.isEmpty ||
        _universityTextController.text.isEmpty ||
        _yearTextController.text.isEmpty) {
      showCustomFlash("please_fill_in_completely".tr, context, isError: true);
      return;
    }
    int response = 0;
    if (photoController.selectedPhoto != null) {
      response = await photoController.uploadImageUrl();
    }
    if (response == 200 || response == 0) {
      User user = User(
          id: widget.user.id,
          displayName: _displayNameTextController.text,
          birthPlace: _birthPlaceTextController.text,
          email: _emailTextController.text,
          username: _usernameTextController.text,
          gender: _valueGender.value,
          image: photoController.photo?.name ?? widget.user.image,
          hasPhoto: true,
          password: widget.user.password,
          confirmPassword: widget.user.password,
          active: true,
          dob: dateBirthDay,
          changePass: null,
          tokenDevice: deviceToken,
          roles: widget.user.roles,
          year: _yearTextController.text.isNotEmpty
              ? int.parse(_yearTextController.text)
              : widget.user.year,
          university: _universityTextController.text);
      if (widget.user.tokenDevice != deviceToken) {
        userController.updateTokenDevice(deviceToken!);
      }
      userController.isAdmin == false
          ? await userController.updateUserMySelf(user).then((response) async {
              if (response == 200) {
                showCustomFlash("success".tr, context, isError: false);
                await Get.find<UserController>()
                    .getCurrentUser()
                    .then((response) {
                  Get.back();
                });
              } else {
                showCustomFlash("fail".tr, context);
              }
            })
          : userController.updateUserById(user).then((response) {
              if (response == 200) {
                showCustomFlash("success".tr, context, isError: false);
              } else {
                showCustomFlash("fail".tr, context);
              }
              Get.back();
            });
    }
  }
}
