// 플래너 탭 = 기존 HomeScreen 그대로
export '../home_screen.dart' show HomeScreen;

import 'package:flutter/material.dart';
import '../home_screen.dart';

class PlannerTab extends StatelessWidget {
  const PlannerTab({super.key});

  @override
  Widget build(BuildContext context) => const HomeScreen();
}
