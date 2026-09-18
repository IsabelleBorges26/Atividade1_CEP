import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/splash_screen.dart';

void main() {
  runApp(const CadastroPessoasApp());
}

class CadastroPessoasApp extends StatelessWidget {
  const CadastroPessoasApp({super.key});

  @override
  Widget build(BuildContext context) {
    const rosa = Color(0xFFE9A6B8);
    const rosaClaro = Color(0xFFFFF4F7);
    const marrom = Color(0xFF5E4B50);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pessoas',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: rosaClaro,
        colorScheme: ColorScheme.fromSeed(
          seedColor: rosa,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: marrom,
          displayColor: marrom,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: rosa,
          foregroundColor: Colors.white,
          centerTitle: false,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Color(0xFFF1D5DC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: rosa, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
