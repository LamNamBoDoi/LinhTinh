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
  const EditProfileScreen({super.key, required this.isMyProfile});
  final bool isMyProfile;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  User user = Get.find<UserController>().currentUser;
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
  DateTime? _timeBirthday;
  RxBool _activeUser = true.obs;
  final RxBool _validateGender = true.obs;
  @override
  void initState() {
    super.initState();
    user = Get.find<UserController>().userUpdate;
    PhotoController photoController = Get.find<PhotoController>();

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
          centerTitle: true,
          backgroundColor: Theme.of(context).secondaryHeaderColor,
        ),
        body: GetBuilder<UserController>(
          builder: (controller) => Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ChangeAvatarWidget(isMyProfile: widget.isMyProfile),
                      const SizedBox(height: 20),
                      Obx(() => SwitchListTile(
                          title: Text("account_status".tr,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color)),
                          value: _activeUser.value,
                          onChanged: (value) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (mounted) {
                              setState(() {
                                user = controller.userUpdate;
                              });
                            }
                            _blockUser(value, user);
                          })),
                      CustomTextField(
                        controller: _displayNameTextController,
                        lable: 'name'.tr,
                        validator: (value) =>
                            value!.isEmpty ? 'please_enter_name'.tr : null,
                      ),
                      CustomTextField(
                        controller: _dateBirthDayTextController,
                        lable: "birth_day".tr,
                        enabled: true,
                        // validator: (value) =>
                        //     value!.isEmpty ? 'please_enter_birth_day'.tr : null,
                        lastIcon: const Icon(Icons.calendar_month),
                        onPressedLastIcon: () async {
                          final DateTime? dateTime =
                              await showRoundedDatePicker(
                            context: context,
                            fontFamily: 'NotoSerif',
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2026),
                            locale: const Locale('en', 'US'),
                            borderRadius: 16,
                            height: 250,
                            imageHeader: const AssetImage(Images.bgDate),
                            styleDatePicker: MaterialRoundedDatePickerStyle(
                              textStyleDayHeader:
                                  const TextStyle(color: Colors.amber),
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
                          if (controller.loading == false) {
                            _updateProfile(controller.userUpdate);
                          }
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
      showCustomFlash('cannot_left_blank'.tr, Get.context!, isError: true);
      return;
    }
    int response = 0;
    if (photoController.selectedPhoto != null) {
      response = await photoController.uploadImageUrl().then((response) {
        if (response != 200) {
          showCustomFlash("please_select_another_photo".tr, Get.context!,
              isError: true);
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
          active: updateUser.active,
          dob: dateBirthDay,
          changePass: null,
          tokenDevice: deviceToken,
          roles: updateUser.roles,
          year: (_yearTextController.text.isNotEmpty &&
                  _yearTextController.text != "null")
              ? int.parse(_yearTextController.text)
              : updateUser.year ?? 0,
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
              await Get.find<UserController>().getCurrentUser();
            }
          });
        }
      } else if (userController.isAdmin == true) {
        if (userController.selectedUser.isEqual(user)) {
          showCustomFlash("nothing_changed".tr, context, isError: true);
        } else {
          await userController.updateUserById(user).then((response) async {
            if (response == 200) {
              _validateGender.value = true;
            }
          });
        }
      }
    }
  }

  void _blockUser(bool value, User user) {
    if (_activeUser.value == true) {
      if (widget.isMyProfile) {
        if (Get.find<UserController>().isAdmin == false) {
          showCustomConfirm(context, "change_account_status".tr, () {
            _activeUser.value = value;
            Get.find<UserController>().blockUser(user.id!, true);
            Navigator.pop(context);
          });
        }
      } else {
        if (Get.find<UserController>().isAdmin &&
            Get.find<UserController>().selectedUser.username != "admin") {
          showCustomConfirm(context, "change_account_status".tr, () {
            _activeUser.value = value;
            Get.find<UserController>().blockUser(user.id!, false);
            Navigator.pop(context);
          });
        }
      }
    } else {
      user.active = true;
      if (widget.isMyProfile) {
        if (Get.find<UserController>().isAdmin == false) {
          showCustomConfirm(context, "change_account_status".tr, () {
            _activeUser.value = value;
            Get.find<UserController>().updateUserMySelf(user);
            Navigator.pop(context);
          });
        }
      } else {
        if (Get.find<UserController>().isAdmin &&
            Get.find<UserController>().selectedUser.username != "admin") {
          showCustomConfirm(context, "change_account_status".tr, () {
            _activeUser.value = value;
            Get.find<UserController>().updateUserById(user);
            Navigator.pop(context);
          });
        }
      }
    }
  }
}
