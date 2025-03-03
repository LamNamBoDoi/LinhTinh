import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class CustomConfirmDialog {
  static void show({
    required BuildContext context,
    required String text,
    required VoidCallback onConfirm,
  }) {
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
}
