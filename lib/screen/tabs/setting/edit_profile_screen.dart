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
  EditProfileScreen({super.key, required this.isMyProfile});
  final bool isMyProfile;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late User user;
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
  final _formKey = GlobalKey<FormState>();
  DateTime? _timeBirthday = null;
  RxBool _activeUser = true.obs;
  RxBool _validateGender = true.obs;
  @override
  void initState() {
    super.initState();
    PhotoController photoController = Get.find<PhotoController>();
    user = widget.isMyProfile
        ? Get.find<UserController>().currentUser
        : Get.find<UserController>().selectedUser;
    photoController.selectedPhoto = null;
    _activeUser = RxBool(user.active ?? true);
    _displayNameTextController.text = user.displayName ?? "";
    _dateBirthDayTextController.text = user.dob ?? "";
    _birthPlaceTextController.text = user.birthPlace ?? "";
    _emailTextController.text = user.email ?? "";
    _usernameTextController.text = user.username ?? "";
    _universityTextController.text = user.university ?? "";
    _yearTextController.text = user.year.toString() ?? "";
    _valueGender.value = user.gender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("edit_profile".tr),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
        ),
        body: GetBuilder<UserController>(
          builder: (controller) => Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ChangeAvatarWidget(isMyProfile: widget.isMyProfile),
                      SizedBox(height: 20),
                      Obx(
                        () => SwitchListTile(
                            title: Text("account_status".tr,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color)),
                            value: _activeUser.value,
                            onChanged: (value) => _blockUser(value)),
                      ),
                      CustomTextField(
                        controller: _displayNameTextController,
                        lable: 'last_name'.tr,
                        validator: (value) =>
                            value!.isEmpty ? 'please_enter_last_name'.tr : null,
                      ),
                      CustomTextField(
                        controller: _dateBirthDayTextController,
                        lable: "birth_day".tr,
                        enabled: true,
                        // validator: (value) =>
                        //     value!.isEmpty ? 'please_enter_birth_day'.tr : null,
                        lastIcon: Icon(Icons.calendar_month),
                        onPressedLastIcon: () async {
                          final DateTime? dateTime =
                              await showRoundedDatePicker(
                            context: context,
                            fontFamily: 'NotoSerif',
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2026),
                            locale: Locale('en', 'US'),
                            borderRadius: 16,
                            height: 250,
                            imageHeader: AssetImage(Images.bgDate),
                            styleDatePicker: MaterialRoundedDatePickerStyle(
                              textStyleDayHeader:
                                  TextStyle(color: Colors.amber),
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
                        lable: "birth_place".tr,
                        // validator: (value) => value!.isEmpty
                        //     ? 'please_enter_birth_place'.tr
                        //     : null,
                      ),
                      SelectGenderWidget(
                        valueGender: _valueGender,
                        validateGender: _validateGender,
                      ),
                      CustomTextField(
                        controller: _emailTextController,
                        lable: "email".tr,
                        validator: (value) =>
                            value!.isEmpty ? 'please_enter_email'.tr : null,
                      ),
                      CustomTextField(
                        controller: _usernameTextController,
                        lable: "username".tr,
                        validator: (value) =>
                            value!.isEmpty ? 'please_enter_username'.tr : null,
                      ),
                      CustomTextField(
                        controller: _universityTextController,
                        lable: "university".tr,
                        validator: (value) => value!.isEmpty
                            ? 'please_enter_university'.tr
                            : null,
                      ),
                      CustomTextField(
                        controller: _yearTextController,
                        lable: "school_year".tr,
                        validator: (value) => value!.isEmpty
                            ? 'Please enter school year'.tr
                            : null,
                      ),
                      CustomButton(
                        width: double.infinity,
                        buttonText: "update".tr,
                        onPressed: () {
                          controller.userUpdate = user;
                          if (controller.loading == false)
                            _updateProfile(controller.userUpdate);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.loading == true)
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),
            ],
          ),
        ));
  }

  void _updateProfile(User updateUser) async {
    FocusScope.of(context).unfocus();
    UserController userController = Get.find<UserController>();
    PhotoController photoController = Get.find<PhotoController>();
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    String? dateBirthDay =
        _timeBirthday != null ? _timeBirthday!.toIso8601String() + "Z" : null;
    final genderValue = _valueGender.value;

    if (!_formKey.currentState!.validate() ||
        genderValue == null ||
        genderValue.isEmpty) {
      if (genderValue == null || genderValue.isEmpty) {
        _validateGender.value = false;
      }
      showCustomSnackBar('cannot_left_blank'.tr);
      return;
    }
    int response = 0;
    if (photoController.selectedPhoto != null) {
      response = await photoController.uploadImageUrl().then((response) {
        if (response != 200) {
          Get.snackbar("error".tr, "please_select_another_photo".tr,
              backgroundColor: Colors.red, colorText: Colors.white);
        }
        return response;
      });
    }
    if (response == 200 || response == 0) {
      User user = User(
          id: updateUser.id,
          displayName: _displayNameTextController.text,
          birthPlace: _birthPlaceTextController.text,
          email: _emailTextController.text,
          username: _usernameTextController.text,
          gender: _valueGender.value,
          image: photoController.photo?.name ?? userController.image,
          hasPhoto: true,
          password: updateUser.password,
          confirmPassword: updateUser.password,
          active: true,
          dob: dateBirthDay,
          changePass: null,
          tokenDevice: deviceToken,
          roles: updateUser.roles,
          year: _yearTextController.text.isNotEmpty
              ? int.parse(_yearTextController.text)
              : updateUser.year,
          university: _universityTextController.text);
      if (user.tokenDevice != deviceToken) {
        userController.updateTokenDevice(deviceToken!);
      }
      if (widget.isMyProfile) {
        if (userController.currentUser.isEqual(user)) {
          showCustomFlash("nothing_changed".tr, context, isError: true);
        } else {
          await userController.updateUserMySelf(user).then((response) async {
            if (response == 200) {
              showCustomFlash("success".tr, context, isError: false);
              await Get.find<UserController>().getCurrentUser();
            } else {
              showCustomFlash("fail".tr, context);
            }
          });
        }
      } else if (userController.isAdmin == true) {
        if (userController.currentUser.isEqual(user)) {
          showCustomFlash("nothing_changed".tr, context, isError: true);
        } else {
          await userController.updateUserById(user).then((response) async {
            if (response == 200) {
              _validateGender.value = true;
              showCustomFlash("success".tr, context, isError: false);
            } else {
              showCustomFlash("fail".tr, context);
            }
          });
        }
      }
    }
  }

  void _blockUser(bool value) {
    if (_activeUser.value == true) {
      if (widget.isMyProfile) {
        if (Get.find<UserController>().currentUser.username != "admin1") {
          showCustomConfirm(context, "change_account_status".tr, () {
            _activeUser.value = value;
            Get.find<UserController>().blockUser(user.id!).then(
                (_) async => await Get.find<UserController>().getListUsers());
            Navigator.pop(context);
          });
        }
      } else {
        if (Get.find<UserController>().currentUser.username == "admin1" &&
            Get.find<UserController>().selectedUser.username != "admin1") {
          showCustomConfirm(context, "change_account_status".tr, () {
            _activeUser.value = value;
            Get.find<UserController>().blockUser(user.id!).then(
                (_) async => await Get.find<UserController>().getListUsers());
            Navigator.pop(context);
          });
        }
      }
    }
  }
}
