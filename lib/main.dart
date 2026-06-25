import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const QuranKarimeApp());
}

class QuranKarimeApp extends StatelessWidget {
  const QuranKarimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'القرآن الكريم',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF0C3E26),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0C3E26),
          primary: const Color(0xFF0C3E26),
          secondary: const Color(0xFFD4AF37),
        ),
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}
