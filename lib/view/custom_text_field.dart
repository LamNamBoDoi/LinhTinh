import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.padding,
    this.width,
    this.controller,
    this.lable,
    this.hintText,
    this.icon,
    this.lastIcon,
    this.isShowPass,
    this.enabled,
    this.autofocus,
    this.inputType,
    this.textInputAction,
    this.onPressedLastIcon,
  });
  final EdgeInsetsGeometry? padding;
  final double? width;
  final TextEditingController? controller;
  final String? lable;
  final String? hintText;
  final Icon? icon;
  final Icon? lastIcon;
  final bool? isShowPass;
  final bool? enabled;
  final bool? autofocus;
  final TextInputType? inputType;
  final TextInputAction? textInputAction;
  final VoidCallback? onPressedLastIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: SizedBox(
        height: 50,
        width: width,
        child: Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: [
              TextFormField(
                enabled: enabled,
                autofocus: autofocus ?? false,
                controller: controller,
                obscureText: isShowPass != null ? !isShowPass! : false,
                textInputAction: textInputAction,
                keyboardType: inputType,
                decoration: InputDecoration(
                  labelText: lable,
                  hintText: hintText,
                  prefixIcon: icon,
                  contentPadding: const EdgeInsets.only(left: 20),
                  border: const OutlineInputBorder(                          // tổng
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(30))
                  ),
                  enabledBorder: const OutlineInputBorder(                   // khi không select
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(30))
                  ),
                  focusedBorder: OutlineInputBorder(                    // khi select
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                      borderRadius: const BorderRadius.all(Radius.circular(30))
                  ),
                  disabledBorder: const OutlineInputBorder(                   // khi bị enable = fasle
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(30))
                  ),
                ),
              ),
              lastIcon != null
                  ? IconButton(
                onPressed: onPressedLastIcon ?? (){},
                icon: lastIcon!,
              )
                  : Container()
            ]
        ),
      ),
    );
  }
}
