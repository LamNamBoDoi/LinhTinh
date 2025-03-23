import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/screen/tabs/setting/edit_profile_screen.dart';

class UserDetailScreen extends StatelessWidget {
  UserDetailScreen({super.key});
  UserController userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("user_details".tr),
        centerTitle: true,
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        elevation: 4,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.black87,
              ),
              onPressed: () {
                if (userController.selectedUser.image == null ||
                    userController.selectedUser.image == "") {
                  userController.image = "";
                } else {
                  userController.image = userController.selectedUser.image!;
                }
                userController.userUpdate = userController.selectedUser;
                Get.to(() => EditProfileScreen(
                      isMyProfile: false,
                      user: userController.userUpdate,
                    ));
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: GetBuilder<UserController>(
            builder: (controller) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: Theme.of(context).secondaryHeaderColor,
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: (controller.selectedUser.image != "" &&
                            controller.selectedUser.image != null)
                        ? NetworkImage(controller.selectedUser
                            .getLinkImageUrl(controller.selectedUser.image!))
                        : AssetImage("assets/image/avatarDefault.jpg")
                            as ImageProvider,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  controller.selectedUser.displayName ?? "Unknown",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                SizedBox(height: 20),
                _buildInfoCard("email".tr, Icons.email,
                    controller.selectedUser.email ?? "N/A", context),
                _buildInfoCard("username".tr, Icons.person,
                    controller.selectedUser.username ?? "N/A", context),
                _buildInfoCard(
                  "status".tr,
                  Icons.circle,
                  controller.selectedUser.active == true
                      ? "active".tr
                      : "inactive".tr,
                  context,
                  color: controller.selectedUser.active == true
                      ? Theme.of(context).secondaryHeaderColor
                      : Colors.red,
                ),
                _buildInfoCard("birth_day".tr, Icons.cake,
                    controller.selectedUser.dob ?? "N/A", context),
                _buildInfoCard("birth_place".tr, Icons.place,
                    controller.selectedUser.birthPlace ?? "N/A", context),
                _buildInfoCard("university".tr, Icons.school,
                    controller.selectedUser.university ?? "N/A", context),
                _buildInfoCard("school_year".tr, Icons.calendar_today,
                    controller.selectedUser.year?.toString() ?? "N/A", context),
              ],
            ),
          )),
    );
  }

  Widget _buildInfoCard(
      String title, IconData icon, String value, BuildContext context,
      {Color? color}) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: color ?? Theme.of(context).secondaryHeaderColor),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
