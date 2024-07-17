import 'package:flutter/material.dart';

ThemeData light({Color color = const Color(0xFF039D55)}) => ThemeData(
  fontFamily: 'Roboto',
  primaryColor: color,
  useMaterial3: false,
  secondaryHeaderColor: const Color(0xFF1ED7AA),
  disabledColor: const Color(0xFFBABFC4),
  brightness: Brightness.light,
  hintColor: const Color(0xFF9F9F9F),
  cardColor: Colors.white,
  colorScheme: ColorScheme.light(primary: color, secondary: color),
);