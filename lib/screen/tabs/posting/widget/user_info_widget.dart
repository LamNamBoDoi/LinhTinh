import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/data/model/body/users/user.dart';

class UserInfoWidget extends StatelessWidget {
  UserInfoWidget({super.key, required this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildInfoRow(Icons.email, user.email ?? "no_email".tr, context),
          _buildInfoRow(Icons.cake, user.dob ?? "no_date_of_birth".tr, context),
          _buildInfoRow(
              Icons.school, user.university ?? "no_school".tr, context),
          _buildInfoRow(
              Icons.perm_contact_calendar_outlined,
              user.year == null ? "no_school_year".tr : user.year.toString(),
              context),
        ],
      ),
    );
  }
}

Widget _buildInfoRow(IconData icon, String text, BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
    ),
    child: Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
      ],
    ),
  );
}
