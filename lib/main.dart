import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/result_screen.dart';
import 'presentation/screens/map_screen.dart';

void main() {
  runApp(const TRApp());
}

class TRApp extends StatelessWidget {
  const TRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TR — 여행 플래너',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0F),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7B6EF6),
          secondary: Color(0xFFFF6B9D),
          surface: Color(0xFF141420),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/result': (context) => const ResultScreen(),
        '/map': (context) => const MapScreen(),
      },
    );
  }
}
