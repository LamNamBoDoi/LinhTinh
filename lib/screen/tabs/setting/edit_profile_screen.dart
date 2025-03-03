import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timesheet/controller/photo_controller.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/data/model/body/users/user.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/custom_button.dart';
import 'package:timesheet/view/custom_snackbar.dart';
import 'package:timesheet/view/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
  User user;
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
  // final TextEditingController _passwordTextController = TextEditingController();
  // final TextEditingController _confirmPasswordTextController =
  //     TextEditingController();

  final _valueGender = Rx<String?>(null);
  // final _showPass = false.obs;
  // final _showConfirmPass = false.obs;
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
        title: Text("edit_profile".tr, style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAvatarSection(context),
            SizedBox(height: 20),
            Obx(
              () => SwitchListTile(
                title: Text("account_status".tr,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge!.color)),
                value: _activeUser.value,
                onChanged: (value) {
                  showCustomConfirm(context, "Thay doi trang trai tai khoan",
                      () {
                    _activeUser.value = value;
                    Get.find<UserController>()
                        .blockUser(widget.user.id!)
                        .then((response) {
                      if (value == 200 || value == 201) {
                        showCustomSnackBar("success".tr, isError: false);
                      } else {
                        showCustomSnackBar("fail".tr, isError: true);
                      }
                      Navigator.pop(context);
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
              enabled: false,
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
                          value: "M",
                          child: Text("male".tr),
                        ),
                      )
                      ..add(
                        DropdownMenuItem(
                          value: "N",
                          child: Text("female".tr),
                        ),
                      )
                      ..add(
                        DropdownMenuItem(
                          value: "O",
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
    );
  }

  Widget _buildAvatarSection(BuildContext context) {
    return GetBuilder<PhotoController>(
      builder: (controller) {
        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: widget.user.image != null
                  ? NetworkImage(
                      widget.user.getLinkImageUrl(widget.user.image!))
                  : AssetImage("assets/image/avatarDefault.jpg")
                      as ImageProvider,
              child: controller.selectedPhoto != null
                  ? ClipOval(
                      child: Image.file(
                        controller.selectedPhoto!,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    )
                  : null,
            ),
            GestureDetector(
              onTap: () => _showImagePicker(context, controller),
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.camera_alt, color: Colors.white, size: 15),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showImagePicker(BuildContext context, PhotoController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Chọn ảnh từ thư viện"),
              onTap: () {
                controller.pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Chụp ảnh mới"),
              onTap: () {
                controller.pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Xóa ảnh"),
              onTap: () {
                UserController userController = Get.find<UserController>();
                userController.deleteImage();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
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
      showCustomFlash("Dien day du di", context, isError: true);
      return;
    }
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
    await photoController.uploadImageUrl();
    if (widget.user.tokenDevice != deviceToken) {
      userController.updateTokenDevice(deviceToken!);
    }
    userController.isAdmin == false
        ? await userController.updateUserMySelf(user).then((response) {
            if (response == 200) {
              showCustomFlash("success".tr, context, isError: false);
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
          });
  }
}
