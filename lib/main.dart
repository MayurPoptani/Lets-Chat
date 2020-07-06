import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_chat/Database/functions.dart';
import 'package:lets_chat/MainPagesScreen/screens/MainPagesScreen.dart';
import 'package:lets_chat/global/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDatabase();
  runApp(LetsChat());
}

class LetsChat extends StatelessWidget {
  
  static bool isDark = false;
  
  @override
  Widget build(BuildContext context) {
    darkTheme = ThemeData.dark().copyWith(
      iconTheme: IconThemeData(color: Colors.white),
      textTheme: GoogleFonts.ralewayTextTheme(ThemeData.dark().textTheme.apply(bodyColor: Colors.white)),
      primaryTextTheme: GoogleFonts.ralewayTextTheme(ThemeData.dark().textTheme.apply(bodyColor: Colors.white)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF212121),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
      ),
      appBarTheme: AppBarTheme(color: Color(0xFF303030), iconTheme: IconThemeData(color: Colors.white),),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.white,
        splashColor: Colors.black26,
      )
    );
    lightTheme = ThemeData.light().copyWith(
      iconTheme: IconThemeData(color: Colors.black),
      textTheme: GoogleFonts.ralewayTextTheme(ThemeData.light().textTheme.apply(bodyColor: Colors.black)),
      primaryTextTheme: GoogleFonts.ralewayTextTheme(ThemeData.dark().textTheme.apply(bodyColor: Colors.black)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black38,
      ),
      appBarTheme: AppBarTheme(color: Colors.white, iconTheme: IconThemeData(color: Colors.black),),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.black87,
      )
    );
    
    
    return ThemeProvider(
      // kept at 500 ms intentially, to check the theme change switch animation
      duration: Duration(milliseconds: 500),
      initTheme: lightTheme,
      child: Builder(builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeProvider.of(context),
          home: MainPagesScreen(),
        );
      }),
    );
  }
}