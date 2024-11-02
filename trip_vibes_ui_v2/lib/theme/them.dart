import 'package:flutter/material.dart';

class AppThemes {
  // Define the light theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xff5100F2),
    colorScheme: ColorScheme.light(
      onPrimary: Colors.white,
      primary: Color(0xff5100F2),
      secondary: Colors.orange,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xff5100F2),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xff5100F2),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xff5100F2),
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: ThemeData.light().textTheme.apply(
    bodyColor: Colors.black,
    displayColor: Colors.grey[700],)
  );

  // Define the dark theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.orange,
    colorScheme: ColorScheme.dark(
      onPrimary: Colors.black,
      primary: Colors.orange,
      secondary: Color(0xff5100F2),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.orange,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.orange,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.orange,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: ThemeData.dark().textTheme.apply(
    bodyColor: Colors.white,
    displayColor: Colors.grey[300],)
  );
}
