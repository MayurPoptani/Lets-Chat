import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  textTheme: GoogleFonts.ralewayTextTheme(ThemeData.dark().textTheme),
  primaryTextTheme: GoogleFonts.ralewayTextTheme(ThemeData.dark().textTheme),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Color(0xFF212121)),
  appBarTheme: AppBarTheme(color: Color(0xFF303030)),
);
ThemeData lightTheme = ThemeData.light().copyWith(
  textTheme: GoogleFonts.ralewayTextTheme(ThemeData.light().textTheme),
  primaryTextTheme: GoogleFonts.ralewayTextTheme(ThemeData.dark().textTheme),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Color(0xFF212121)),
  appBarTheme: AppBarTheme(color: Color(0xFF303030)),
);