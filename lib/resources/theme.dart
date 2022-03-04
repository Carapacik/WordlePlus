import 'package:flutter/material.dart';

enum AppTheme {
  lightTheme,
  darkTheme,
}

final themes = {
  AppTheme.lightTheme: ThemeData(
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headline6: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    primaryColorDark: const Color(0xFF0097A7),
    primaryColorLight: const Color(0xFFFFFFFF),
    primaryColor: const Color(0xFF000000),
    colorScheme: const ColorScheme.light(secondary: Color(0xFF009688)),
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  AppTheme.darkTheme: ThemeData(
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headline6: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    ),
    primaryColorDark: const Color(0xDCDA2EF3),
    primaryColorLight: const Color(0xDC121213),
    primaryColor: const Color(0xFFFFFFFF),
    colorScheme: const ColorScheme.light(secondary: Color(0xFFE575F3)),
    scaffoldBackgroundColor: const Color(0xDC121213),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  )
};