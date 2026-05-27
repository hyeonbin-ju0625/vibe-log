import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tabs/home_tab.dart';
import 'tabs/planner_tab.dart';
import 'tabs/my_trips_tab.dart';
import 'tabs/my_tab.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const kBg      = Color(0xFFF6F7FF);
  static const kSurface = Color(0xFFFFFFFF);
  static const kBorder  = Color(0xFFE4E6F5);
  static const kPrimary = Color(0xFF7B6EF6);
  static const kSecond  = Color(0xFFFF6B9D);
  static const kSub     = Color(0xFF9496B0);

  final _tabs = const [
    HomeTab(),
    PlannerTab(),
    MyTripsTab(),
    MyTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        border: Border(top: BorderSide(color: kBorder, width: 1)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B6EF6).withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              _navItem(0, Icons.explore_rounded,      Icons.explore_outlined,       '홈'),
              _navItem(1, Icons.auto_awesome_rounded, Icons.auto_awesome_outlined,  '플래너'),
              _navItem(2, Icons.luggage_rounded,      Icons.luggage_outlined,       '내 여행'),
              _navItem(3, Icons.person_rounded,       Icons.person_outline_rounded, '마이페이지'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isActive = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 2,
              width: isActive ? 28 : 0,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                gradient: isActive
                    ? const LinearGradient(colors: [kPrimary, kSecond])
                    : null,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : inactiveIcon,
                key: ValueKey(isActive),
                color: isActive ? kPrimary : kSub,
                size: 22,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? kPrimary : kSub,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
