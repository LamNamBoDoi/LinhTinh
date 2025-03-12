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
            ? () => Get.to(() => UserDetailScreen(user: user))
            : null,
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: user.image != null
              ? NetworkImage(user.getLinkImageUrl(user.image!))
              : null,
          child: user.image == null ? const Icon(Icons.person, size: 30) : null,
        ),
        title: Text(user.displayName ?? "No Name",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
