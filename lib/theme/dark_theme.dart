import 'package:flutter/material.dart';

ThemeData dark({Color color = const Color(0xFF54b46b)}) => ThemeData(
      fontFamily: 'Roboto',
      primaryColor: color,
      useMaterial3: false,
      secondaryHeaderColor: const Color(0xFF009f67),
      disabledColor: const Color(0xffa2a7ad),
      brightness: Brightness.dark,
      hintColor: const Color(0xFFbebebe),
      cardColor: Colors.black,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white), // Dùng cho nội dung chính
        bodyMedium: TextStyle(color: Colors.white54),
        titleLarge:
            TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
      ),
      colorScheme: ColorScheme.dark(primary: color, secondary: color),
    );
