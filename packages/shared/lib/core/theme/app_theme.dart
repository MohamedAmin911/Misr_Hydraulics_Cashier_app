import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: const Color(0xFF2563EB), // modern blue
  );

  final textTheme = GoogleFonts.tajawalTextTheme(base.textTheme);

  return base.copyWith(
    textTheme: textTheme,
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      isDense: true,
    ),
    appBarTheme: const AppBarTheme(centerTitle: true),
    visualDensity: VisualDensity.comfortable,
  );
}
