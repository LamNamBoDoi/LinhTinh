import 'package:flutter/material.dart';
import 'package:timesheet/utils/color_resources.dart';
import 'package:timesheet/utils/dimensions.dart';

class CustomAlertDialog extends StatelessWidget {
  CustomAlertDialog(
      {super.key,
      required this.title,
      this.borderRaduius = 15,
      required this.contentController,
      required this.onPress});
  final double borderRaduius;
  final String title;
  final TextEditingController contentController;
  Function onPress;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRaduius)),
      scrollable: true,
      title: Center(
        child: Text(
          title,
          style: TextStyle(
              color: ColorResources.ssColor[2],
              fontSize: Dimensions.FONT_SIZE_EXTRA_OVER_LARGE,
              fontWeight: FontWeight.bold),
        ),
      ),
      content: Padding(
        padding: EdgeInsets.all(5),
        child: TextField(
          controller: contentController,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text(
                "Đóng",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                    fontWeight: FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: () {
                onPress();
                Navigator.of(context).pop();
              },
              child: const Text(
                "Ok",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
