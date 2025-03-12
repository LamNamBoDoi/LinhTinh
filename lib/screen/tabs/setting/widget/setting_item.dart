import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  SettingItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
  });
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
