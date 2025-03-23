import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/data/model/body/users/user.dart';
import 'package:timesheet/screen/tabs/users/user_detail_screen.dart';

class UserItem extends StatelessWidget {
  UserItem({
    super.key,
    required this.userController,
    required this.user,
  });
  final UserController userController;
  final User user;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: userController.isAdmin
            ? () {
                if (user.image == null || user.image == "") {
                  userController.image = "";
                } else {
                  userController.image = user.image!;
                }
                Get.to(() => UserDetailScreen());
                userController.selectedUser = user;
              }
            : null,
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: (user.image != "" && user.image != null)
              ? NetworkImage(user.getLinkImageUrl(user.image!))
              : AssetImage("assets/image/avatarDefault.jpg") as ImageProvider,
        ),
        title: Text(user.displayName ?? "No Name",
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black)),
        subtitle: Text(user.email ?? "No Email",
            style: TextStyle(color: Colors.grey[600])),
        trailing: Icon(
          user.active! ? Icons.check_circle : Icons.cancel,
          color: user.active!
              ? Theme.of(context).secondaryHeaderColor
              : Colors.red,
        ),
      ),
    );
  }
}
