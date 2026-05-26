import 'package:flutter/material.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
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