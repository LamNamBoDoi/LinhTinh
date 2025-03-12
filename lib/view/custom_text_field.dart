import 'package:flutter/material.dart';
import 'package:timesheet/utils/color_resources.dart';

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
      child: Container(
        height: height ?? 50,
        width: width,
        child: Stack(alignment: AlignmentDirectional.centerEnd, children: [
          TextFormField(
            enabled: enabled,
            onChanged: (text) {
              // Nếu onChange được truyền vào, gọi nó với text mới
              onChange?.call(text);
            },
            maxLines: isShowPass == false ? 1 : null,
            autofocus: autofocus ?? false,
            controller: controller,
            textAlign: textAlign ?? TextAlign.left,
            obscureText: isShowPass != null ? !isShowPass! : false,
            textInputAction: textInputAction,
            keyboardType: inputType,
            style: TextStyle(
                color:
                    colorText ?? Theme.of(context).textTheme.bodyLarge!.color),
            decoration: InputDecoration(
              labelText: lable,
              hintStyle: TextStyle(
                  color: colorHint ??
                      Theme.of(context).textTheme.bodyLarge!.color),
              hintText: hintText,
              prefixIcon: icon,
              contentPadding: contentPadding ?? EdgeInsets.all(10),
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: ColorResources.ssColor[4], width: 2),
                  borderRadius: BorderRadius.all(
                      radius ?? radius ?? Radius.circular(30))),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: ColorResources.ssColor[4], width: 1),
                  borderRadius:
                      BorderRadius.all(radius ?? const Radius.circular(30))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 2),
                  borderRadius:
                      BorderRadius.all(radius ?? const Radius.circular(30))),
              disabledBorder: OutlineInputBorder(
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
