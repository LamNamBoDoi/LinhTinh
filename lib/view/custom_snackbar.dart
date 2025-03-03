import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import '../helper/responsive_helper.dart';
import '../utils/dimensions.dart';
import '../utils/styles.dart';
import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';

void showCustomSnackBar(String message, {bool isError = true}) {
  if (message.isNotEmpty) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      dismissDirection: DismissDirection.horizontal,
      margin: EdgeInsets.only(
        right: ResponsiveHelper.isDesktop(Get.context)
            ? Get.context!.width * 0.7
            : Dimensions.PADDING_SIZE_SMALL,
        top: Dimensions.PADDING_SIZE_SMALL,
        bottom: Dimensions.PADDING_SIZE_SMALL,
        left: Dimensions.PADDING_SIZE_SMALL,
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      content: Text(message, style: robotoMedium.copyWith(color: Colors.white)),
    ));
  }
}

void showCustomFlash(String message, BuildContext context,
    {bool isError = true}) {
  if (message.isNotEmpty) {
    context.showFlash<bool>(
      barrierColor: Colors.transparent,
      barrierBlur: 0,
      duration: Duration(seconds: 2),
      barrierDismissible: true,
      builder: (context, controller) => FlashBar(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(15),
        useSafeArea: true,
        backgroundColor:
            isError == false ? Color(0xFFF0FFF0) : Color(0xFFF8E4CC),
        behavior: FlashBehavior.floating,
        controller: controller,
        position: FlashPosition.top,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        icon: isError == false
            ? Icon(
                Icons.check_circle,
                color: Color(0xFF32CD32),
              )
            : Icon(
                Icons.cancel,
                color: Color(0xFFF20231),
              ),
        content: Text(
          message,
          style: isError == false
              ? TextStyle(
                  color: Color(0xFF32CD32), fontSize: Dimensions.fontSizeLarge)
              : TextStyle(
                  color: Color(0xFFF20231), fontSize: Dimensions.fontSizeLarge),
        ),
      ),
    );
  }
}

void showCustomConfirm(BuildContext context, String text, Function onConfirm) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.confirm,
    text: text,
    confirmBtnText: 'Yes',
    cancelBtnText: 'No',
    confirmBtnColor: Theme.of(context).secondaryHeaderColor,
    onConfirmBtnTap: () => onConfirm(),
  );
}
