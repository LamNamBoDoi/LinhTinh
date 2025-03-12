import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/data/model/body/users/user.dart';
import 'package:timesheet/screen/tabs/setting/edit_profile_screen.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;
  UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User"),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.black87,
              ),
              onPressed: () {
                Get.to(() => EditProfileScreen(user: user));
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: user.image != null
                  ? NetworkImage(user.getLinkImageUrl(user.image!))
                  : const AssetImage("assets/image/avatarDefault.jpg")
                      as ImageProvider,
            ),
            SizedBox(height: 16),
            Text(
              user.displayName ?? "Unknown User",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            SizedBox(height: 16),
            Divider(
              color: Theme.of(context).secondaryHeaderColor,
            ),
            _buildInfoRow("Email", user.email ?? "N/A", context),
            _buildInfoRow("Username", user.username ?? "N/A", context),
            _buildInfoRow(
                "Active", user.active == true ? "on" : "off", context),
            _buildInfoRow("Birth Date", user.dob ?? "N/A", context),
            _buildInfoRow("Birth Place", user.birthPlace ?? "N/A", context),
            _buildInfoRow("University", user.university ?? "N/A", context),
            _buildInfoRow("Year", user.year?.toString() ?? "N/A", context),
            Divider(
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodySmall?.color),
          ),
        ],
      ),
    );
  }
}
