import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      this.padding,
      this.width,
      this.height,
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
      this.textAlign,
      this.contentPadding,
      this.colorText,
      this.colorHint,
      this.onChange,
      this.radius});
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
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
  final Radius? radius;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final Color? colorText;
  final Color? colorHint;
  final Function? onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: SizedBox(
        height: height,
        width: width,
        child: Stack(alignment: AlignmentDirectional.centerEnd, children: [
          TextFormField(
            enabled: enabled,
            onChanged: (text) {
              // Nếu onChange được truyền vào, gọi nó với text mới
              onChange?.call(text);
            },
            autofocus: autofocus ?? false,
            controller: controller,
            textAlign: textAlign ?? TextAlign.left,
            obscureText: isShowPass != null ? !isShowPass! : false,
            textInputAction: textInputAction,
            keyboardType: inputType,
            style: TextStyle(color: colorText ?? Colors.black),
            decoration: InputDecoration(
              labelText: lable,
              hintStyle: TextStyle(color: colorHint ?? Colors.black),
              hintText: hintText,
              prefixIcon: icon,
              contentPadding: contentPadding ?? EdgeInsets.only(left: 20),
              border: OutlineInputBorder(
                  // tổng
                  borderSide: const BorderSide(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.all(
                      radius ?? radius ?? Radius.circular(30))),
              enabledBorder: OutlineInputBorder(
                  // khi không select
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                  borderRadius:
                      BorderRadius.all(radius ?? const Radius.circular(30))),
              focusedBorder: OutlineInputBorder(
                  // khi select
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 2),
                  borderRadius:
                      BorderRadius.all(radius ?? const Radius.circular(30))),
              disabledBorder: OutlineInputBorder(
                  // khi bị enable = fasle
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                  borderRadius:
                      BorderRadius.all(radius ?? const Radius.circular(30))),
            ),
          ),
          lastIcon != null
              ? IconButton(
                  onPressed: onPressedLastIcon ?? () {},
                  icon: lastIcon!,
                )
              : Container()
        ]),
      ),
    );
  }
}
