import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: Color(0xFFFF6D6D),
  secondaryHeaderColor: Color(0xFF4794FF),
  disabledColor: Color(0xFFBABFC4),
  backgroundColor: Color(0xFFFCFCFC),
  errorColor: Color(0xFFE84D4F),
  brightness: Brightness.light,

  hintColor: Color(0xFF9F9F9F),
  cardColor: Colors.white,
  textTheme: TextTheme(
    titleLarge: TextStyle(color: Color(0xFF334257)),
    titleSmall: TextStyle(color: Color(0xFF25282D)),
  ),
  colorScheme: ColorScheme.light(primary: Color(0xFFdcb247), secondary: Color(0xFFdcb247)),
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: Color(0xFFdcb247))),
  appBarTheme: AppBarTheme(backgroundColor:  Colors.white)
);