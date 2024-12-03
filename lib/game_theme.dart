import 'package:flutter/material.dart';

final ThemeData gameTheme = ThemeData(
  primarySwatch: Colors.blue,
  hintColor: Colors.green,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white, fontSize: 34),
    bodyMedium: TextStyle(color: Colors.white, fontSize: 20),
    bodySmall: TextStyle(color: Colors.white, fontSize: 18),
    headlineMedium: TextStyle(color: Colors.white, fontSize: 24),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blueAccent,
    textTheme: ButtonTextTheme.primary,
  ),
);