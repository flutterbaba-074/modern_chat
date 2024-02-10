import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color(0xff6A40C9),
      secondary: Colors.black,
      background: Colors.white,
      onPrimary: Colors.white,
      onBackground: Colors.black,
    ));
final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xff6A40C9),
      secondary: Colors.black,
      onPrimary: Colors.white,
      background: Colors.black,
      onBackground: Colors.white,
    ));
