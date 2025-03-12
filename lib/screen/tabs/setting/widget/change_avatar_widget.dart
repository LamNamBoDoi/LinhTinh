import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timesheet/controller/photo_controller.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/data/model/body/users/user.dart';

class ChangeAvatarWidget extends StatelessWidget {
  const ChangeAvatarWidget({super.key, required this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PhotoController>(
      builder: (controller) {
        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: user.image != null
                  ? NetworkImage(user.getLinkImageUrl(user.image!))
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
              title: Text("select_photo_from_library".tr),
              onTap: () {
                controller.pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("take_a_new_photo".tr),
              onTap: () {
                controller.pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("delete_photo".tr),
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
}
