import 'package:flutter/material.dart';

import '../utils/dimensions.dart';
import '../utils/styles.dart';

class CustomButton extends StatelessWidget {
  final Function()? onPressed;
  final String? buttonText;
  final bool? off;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? radius;
  final IconData? icon;

  CustomButton(
      {this.onPressed,
      this.buttonText,
      this.off = false,
      this.margin,
      this.width,
      this.height,
      this.fontSize,
      this.radius = 5,
      this.icon});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onPressed == null
          ? Theme.of(context).disabledColor
          : off!
              ? Colors.grey
              : Theme.of(context).secondaryHeaderColor,
      minimumSize: Size(width != null ? width! : Dimensions.WEB_MAX_WIDTH,
          height != null ? height! : 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius!),
      ),
    );

    return Center(
        child: SizedBox(
            width: width ?? Dimensions.WEB_MAX_WIDTH,
            child: Padding(
              padding: margin == null ? const EdgeInsets.all(0) : margin!,
              child: TextButton(
                onPressed: onPressed,
                style: flatButtonStyle,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  icon != null
                      ? Padding(
                          padding: const EdgeInsets.only(
                              right: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Icon(icon,
                              color: off!
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).cardColor),
                        )
                      : const SizedBox(),
                  Text(buttonText ?? '',
                      textAlign: TextAlign.center,
                      style: robotoBold.copyWith(
                        color:
                            off! ? Theme.of(context).cardColor : Colors.white,
                        fontSize: fontSize ?? Dimensions.fontSizeLarge,
                      )),
                ]),
              ),
            )));
  }
}
