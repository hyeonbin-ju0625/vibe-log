import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/screens/main_shell.dart';
import 'presentation/screens/result_screen.dart';
import 'presentation/screens/map_screen.dart';

void main() {
  runApp(const ProviderScope(child: TRApp()));
}

class TRApp extends StatelessWidget {
  const TRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TR — 여행 플래너',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF6F7FF),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF7B6EF6),
          secondary: Color(0xFFFF6B9D),
          surface: Color(0xFFFFFFFF),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/':       (context) => const MainShell(),
        '/result': (context) => const ResultScreen(),
        '/map':    (context) => const MapScreen(),
      },
    );
  }
}
