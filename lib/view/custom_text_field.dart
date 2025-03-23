import 'package:flutter/material.dart';
import 'package:timesheet/utils/color_resources.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
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
    this.radius,
    this.validator,
  });

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
  final String? Function(String?)? validator;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ??
          (hasError
              ? EdgeInsets.only(bottom: 10, right: 10, left: 10)
              : EdgeInsets.only(bottom: 20, right: 10, left: 10)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: widget.height ?? (hasError ? 70 : 50), // Chỉ tăng khi có lỗi
        width: widget.width,
        child: TextFormField(
          validator: (value) {
            final error = widget.validator?.call(value);
            setState(() => hasError = error != null);
            return error;
          },
          enabled: widget.enabled,
          onChanged: (text) => widget.onChange?.call(text),
          maxLines: widget.isShowPass == false ? 1 : null,
          autofocus: widget.autofocus ?? false,
          controller: widget.controller,
          textAlign: widget.textAlign ?? TextAlign.left,
          obscureText: widget.isShowPass != null ? !widget.isShowPass! : false,
          textInputAction: widget.textInputAction,
          keyboardType: widget.inputType,
          style: TextStyle(
            color: widget.colorText ??
                Theme.of(context).textTheme.bodyLarge!.color,
          ),
          decoration: InputDecoration(
            labelText: widget.lable,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: widget.colorHint ??
                  Theme.of(context).textTheme.bodyLarge!.color,
            ),
            prefixIcon: widget.icon,
            suffixIcon: widget.lastIcon != null
                ? IconButton(
                    onPressed: widget.onPressedLastIcon ?? () {},
                    icon: widget.lastIcon!,
                  )
                : null,
            contentPadding: widget.contentPadding ?? const EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: ColorResources.ssColor[4], width: 2),
              borderRadius:
                  BorderRadius.all(widget.radius ?? const Radius.circular(30)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: ColorResources.ssColor[4], width: 1),
              borderRadius:
                  BorderRadius.all(widget.radius ?? const Radius.circular(30)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 2),
              borderRadius:
                  BorderRadius.all(widget.radius ?? const Radius.circular(30)),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 1),
              borderRadius:
                  BorderRadius.all(widget.radius ?? const Radius.circular(30)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(30),
            ),
            errorStyle: const TextStyle(height: 0.8, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
