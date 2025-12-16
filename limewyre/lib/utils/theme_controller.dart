import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:limewyre/utils/const_page.dart';

class ThemeController {
  final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: ColorConst.backgroundColor,
    primaryColor: ColorConst.primaryColor,
    cardColor: ColorConst.accent,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorConst.backgroundColor,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: ColorConst.textColor),
      titleTextStyle: GoogleFonts.poppins(
        color: ColorConst.textColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
    iconTheme: const IconThemeData(color: ColorConst.textColor),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ColorConst.primaryColor,
      foregroundColor: ColorConst.textColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConst.accent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorConst.primaryColor,
        side: const BorderSide(color: ColorConst.primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white24,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      hintStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: ColorConst.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      errorStyle: GoogleFonts.poppins(
        color: Colors.red,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: ColorConst.textColor,
      displayColor: ColorConst.textColor,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorConst.primaryColor,
        textStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    brightness: Brightness.light,
    // colorScheme: const ColorScheme.dark(
    //   primary: Colors.black,
    //   secondary: Colors.black,
    //   surface: Color(0xFF1C1C1E),
    //   onPrimary: Colors.white,
    //   onSecondary: Colors.white,
    //   onSurface: Colors.white,
    // ),
  );
}
