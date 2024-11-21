import 'package:flutter/material.dart';

class ThemeRepository {
  static const themeModes = {
    'ThemeMode.dark': ThemeMode.dark,
    'ThemeMode.light': ThemeMode.light,
    'ThemeMode.system': ThemeMode.system
  };

  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      color: Colors.grey[300],
      titleTextStyle: TextStyle(color: Colors.grey[700], fontSize: 19, fontWeight: FontWeight.bold),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.grey[850]),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey.shade300,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.blueGrey.shade300),
    sliderTheme: SliderThemeData(
      inactiveTrackColor: Colors.grey.shade700,
      activeTrackColor: Colors.green.shade700,
      thumbColor: Colors.green.shade800,
      showValueIndicator: ShowValueIndicator.always,
      valueIndicatorTextStyle: const TextStyle(color: Colors.red),
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: Colors.grey[400],
      contentPadding: const EdgeInsets.all(7.0),
      labelStyle: const TextStyle(color: Colors.blueGrey),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade500),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade500),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
    ),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      color: Colors.grey[850],
      titleTextStyle: TextStyle(color: Colors.grey[300], fontSize: 19, fontWeight: FontWeight.bold),
    ),
    scaffoldBackgroundColor: Colors.grey[800],
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.grey[150]),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.blueGrey),
    sliderTheme: SliderThemeData(
      inactiveTrackColor: Colors.grey.shade700,
      activeTrackColor: Colors.green.shade700,
      thumbColor: Colors.grey.shade300,
      showValueIndicator: ShowValueIndicator.always,
      valueIndicatorTextStyle: const TextStyle(color: Colors.red),
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: Colors.grey[850],
      contentPadding: const EdgeInsets.all(7.0),
      labelStyle: const TextStyle(color: Colors.blueGrey),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade500),
      ),
    ),
  );
}
