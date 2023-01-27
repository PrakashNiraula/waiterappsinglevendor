import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
    fontFamily: 'Roboto',
    primaryColor: Color(0xFFff9897),
    secondaryHeaderColor: Color(0xFFbfdeff),
    disabledColor: Color(0xffa2a7ad),
    backgroundColor: Color(0xFF212326),
    errorColor: Color(0xFFdd3135),
    brightness: Brightness.dark,
    hintColor: Color(0xFFbebebe),
    cardColor: Color(0xFF334257).withOpacity(0.27),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Color(0xFF8e9fb9)),
      titleSmall: TextStyle(color: Color(0xFFe4e8ef)),
    ),
    colorScheme: ColorScheme.dark(primary: Color(0xFFcda335), secondary: Color(0xFFcda335)),
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: Color(0xFFcda335))),
    appBarTheme: AppBarTheme(backgroundColor:  Color(0x4D334257))
);
