import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timesheet/controller/photo_controller.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/data/model/body/users/user.dart';
import 'package:timesheet/view/custom_snackbar.dart';

class ChangeAvatarWidget extends StatefulWidget {
  const ChangeAvatarWidget({super.key, required this.isMyProfile});
  final bool isMyProfile;

  @override
  State<ChangeAvatarWidget> createState() => _ChangeAvatarWidgetState();
}

class _ChangeAvatarWidgetState extends State<ChangeAvatarWidget> {
  late User user;
  @override
  void initState() {
    super.initState();
    user = widget.isMyProfile
        ? Get.find<UserController>().currentUser
        : Get.find<UserController>().selectedUser;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PhotoController>(
      builder: (photoController) {
        return GetBuilder<UserController>(
          builder: (userController) {
            return Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: userController.image != ""
                      ? NetworkImage(user.getLinkImageUrl(userController.image))
                      : AssetImage("assets/image/avatarDefault.jpg")
                          as ImageProvider,
                  child: photoController.selectedPhoto != null
                      ? ClipOval(
                          child: Image.file(
                            photoController.selectedPhoto!,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        )
                      : null,
                ),
                GestureDetector(
                  onTap: () => _showImagePicker(
                      context, photoController, userController),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.blueAccent,
                    child:
                        Icon(Icons.camera_alt, color: Colors.white, size: 15),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showImagePicker(BuildContext context, PhotoController photoController,
      UserController userController) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                margin: EdgeInsets.only(bottom: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.photo_library, color: Colors.blue),
                  title: Text(
                    "select_photo_from_library".tr,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  onTap: () {
                    photoController.pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
              ),
              Card(
                margin: EdgeInsets.only(bottom: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.camera_alt, color: Colors.green),
                  title: Text(
                    "take_a_new_photo".tr,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  onTap: () {
                    photoController.pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
              ),
              Card(
                margin: EdgeInsets.only(bottom: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    "delete_photo".tr,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  onTap: () {
                    if (photoController.selectedPhoto != null ||
                        user.image != "") {
                      userController.deleteImage();
                    } else {
                      showCustomFlash(
                        "please_select_photo".tr,
                        context,
                        isError: true,
                      );
                    }
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
