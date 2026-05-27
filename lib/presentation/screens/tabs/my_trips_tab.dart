import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/trip_provider.dart';
import '../../../data/models/trip_plan.dart';

class MyTripsTab extends ConsumerWidget {
  const MyTripsTab({super.key});

  static const kBg      = Color(0xFFF6F7FF);
  static const kSurface = Color(0xFFFFFFFF);
  static const kBorder  = Color(0xFFE4E6F5);
  static const kPrimary = Color(0xFF7B6EF6);
  static const kSecond  = Color(0xFFFF6B9D);
  static const kMint    = Color(0xFF00C49A);
  static const kText    = Color(0xFF1E1B4B);
  static const kSub     = Color(0xFF9496B0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planState = ref.watch(tripPlanProvider);
    final hasPlan   = planState is TripPlanSuccess;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            Expanded(
              child: hasPlan
                  ? _tripList(context, planState.plan)
                  : _emptyState(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('내 여행',
              style: GoogleFonts.poppins(
                  fontSize: 28, fontWeight: FontWeight.w800, color: kText)),
          Text('만들어둔 여행 일정이에요',
              style: GoogleFonts.poppins(fontSize: 13, color: kSub)),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96, height: 96,
            decoration: BoxDecoration(
              color: kSurface,
              shape: BoxShape.circle,
              border: Border.all(color: kBorder),
              boxShadow: [BoxShadow(
                  color: kPrimary.withValues(alpha: 0.08),
                  blurRadius: 16, offset: const Offset(0, 4))],
            ),
            child: const Icon(Icons.luggage_outlined,
                color: kSub, size: 44),
          ),
          const SizedBox(height: 24),
          Text('아직 저장된 여행이 없어요',
              style: GoogleFonts.poppins(
                  fontSize: 17, fontWeight: FontWeight.w700, color: kText)),
          const SizedBox(height: 8),
          Text('플래너에서 첫 여행 일정을 만들어보세요',
              style: GoogleFonts.poppins(fontSize: 13, color: kSub)),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [kPrimary, kSecond]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(
                  color: kPrimary.withValues(alpha: 0.35),
                  blurRadius: 16, offset: const Offset(0, 6))],
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.add_rounded,
                  color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text('첫 여행 만들기',
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _tripList(BuildContext context, TripPlan plan) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      children: [
        _tripCard(context: context, plan: plan,
            onTap: () => Navigator.pushNamed(context, '/result')),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/'),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kBorder),
              boxShadow: [BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [kPrimary, kSecond]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.add_rounded,
                      color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Text('새 여행 일정 추가',
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w600,
                        color: kPrimary)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tripCard({
    required BuildContext context,
    required TripPlan plan,
    required VoidCallback onTap,
  }) {
    final req = plan.request;
    final destinations = {
      '도쿄': '🗼', '파리': '🥐', '발리': '🌴',
      '뉴욕': '🗽', '방콕': '🏯', '제주': '🌊',
    };
    final emoji = destinations[req.destination] ?? '✈️';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: kBorder),
          boxShadow: [BoxShadow(
              color: kPrimary.withValues(alpha: 0.08),
              blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF7B6EF6), Color(0xFFFF6B9D)]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(
                      color: kPrimary.withValues(alpha: 0.3),
                      blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Center(child: Text(emoji,
                    style: const TextStyle(fontSize: 26))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(req.destination,
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w800,
                            color: kText)),
                    Text(plan.summary,
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: kSub),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: kSub, size: 22),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              _badge(Icons.calendar_today_rounded,
                  '${req.days}박 ${req.days + 1}일', kPrimary),
              const SizedBox(width: 8),
              _badge(Icons.wallet_rounded,
                  '${(req.budget / 10000).round()}만원', kSecond),
              const SizedBox(width: 8),
              _badge(Icons.place_rounded,
                  '${plan.places.length}개 장소', kMint),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _badge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: color, size: 12),
        const SizedBox(width: 5),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 11, fontWeight: FontWeight.w600,
                color: kText)),
      ]),
    );
  }
}
