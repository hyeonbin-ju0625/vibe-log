import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/trip_provider.dart';
import '../../data/models/place.dart';
import '../../data/models/trip_plan.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  int _filter = 0;

  static const kBg      = Color(0xFFF6F7FF);
  static const kSurface = Color(0xFFFFFFFF);
  static const kBorder  = Color(0xFFE4E6F5);
  static const kPrimary = Color(0xFF7B6EF6);
  static const kSecond  = Color(0xFFFF6B9D);
  static const kText    = Color(0xFF1E1B4B);
  static const kSub     = Color(0xFF9496B0);

  @override
  Widget build(BuildContext context) {
    final planState = ref.watch(tripPlanProvider);
    final plan = planState is TripPlanSuccess ? planState.plan : null;
    final locs = plan == null
        ? <Place>[]
        : (_filter == 0 ? plan.places : plan.placesForDay(_filter));

    return Scaffold(
      backgroundColor: kBg,
      body: Column(children: [
        _header(context, plan),
        _mapArea(locs),
        _filterRow(plan),
        Expanded(child: _locationList(locs)),
      ]),
    );
  }

  Widget _header(BuildContext ctx, TripPlan? plan) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7B6EF6), Color(0xFFa855f7)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Row(children: [
            GestureDetector(
              onTap: () => Navigator.pop(ctx),
              child: Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25)),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 18),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('📍  지도로 보기',
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w800,
                        color: Colors.white)),
                Text(plan != null
                    ? '${plan.request.destination} 일정 장소'
                    : '일정 장소를 한눈에 확인하세요',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.75))),
              ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: Text('${plan?.places.length ?? 0}개 장소',
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _mapArea(List<Place> locs) {
    return Container(
      height: 230,
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: [BoxShadow(
            color: kPrimary.withValues(alpha: 0.12),
            blurRadius: 20, offset: const Offset(0, 6))],
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          const h = 230.0;
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFEEEBFF), Color(0xFFF5F0FF)],
                  ),
                ),
              ),
              CustomPaint(
                  size: Size(w, h), painter: _LightMapPainter()),
              for (final loc in locs)
                Positioned(
                  left: loc.mapX * w - 14,
                  top:  loc.mapY * h - 20,
                  child: _pin(loc),
                ),
              Positioned(
                bottom: 12, right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kBorder),
                    boxShadow: [BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8)],
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      width: 20, height: 20,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [kPrimary, kSecond]),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.map_rounded,
                          color: Colors.white, size: 12),
                    ),
                    const SizedBox(width: 8),
                    Text('Google Maps 연동 예정',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 11, color: kText)),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _pin(Place loc) {
    final c = loc.color;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 30, height: 30,
        decoration: BoxDecoration(
          color: c,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [BoxShadow(
              color: c.withValues(alpha: 0.5), blurRadius: 8)],
        ),
        child: Center(child: Text(loc.emoji,
            style: const TextStyle(fontSize: 14))),
      ),
      Container(width: 2, height: 6, color: c),
      Container(width: 5, height: 5,
          decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
    ]);
  }

  Widget _filterRow(TripPlan? plan) {
    if (plan == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          _filterChip('전체', 0),
          for (int d = 1; d <= plan.totalDays; d++) ...[
            const SizedBox(width: 8),
            _filterChip('Day $d', d),
          ],
        ]),
      ),
    );
  }

  Widget _filterChip(String label, int val) {
    final sel = _filter == val;
    return GestureDetector(
      onTap: () => setState(() => _filter = val),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: sel
              ? const LinearGradient(colors: [kPrimary, kSecond])
              : null,
          color: sel ? null : kSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: sel ? Colors.transparent : kBorder),
          boxShadow: sel
              ? [BoxShadow(color: kPrimary.withValues(alpha: 0.3),
                  blurRadius: 10, offset: const Offset(0, 3))]
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Text(label,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                color: sel ? Colors.white : kSub)),
      ),
    );
  }

  Widget _locationList(List<Place> locs) {
    if (locs.isEmpty) {
      return Center(child: Text('장소 정보가 없어요',
          style: GoogleFonts.poppins(color: kSub, fontSize: 14)));
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      itemCount: locs.length,
      itemBuilder: (context, i) {
        final loc = locs[i];
        final c   = loc.color;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: kSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: kBorder),
            boxShadow: [BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(children: [
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: c.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: c.withValues(alpha: 0.25)),
              ),
              child: Center(child: Text(loc.emoji,
                  style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc.name,
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w700,
                          color: kText)),
                  const SizedBox(height: 3),
                  Text(loc.time,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: kSub)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: c.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: c.withValues(alpha: 0.25)),
              ),
              child: Text('Day ${loc.day}',
                  style: GoogleFonts.poppins(
                      color: c, fontSize: 12, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right_rounded,
                color: kSub.withValues(alpha: 0.5), size: 20),
          ]),
        );
      },
    );
  }
}

class _LightMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFDDD8FF)
      ..strokeWidth = 0.8;
    for (double y = 0; y < size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    for (double x = 0; x < size.width; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    final blockPaint = Paint()..color = const Color(0xFFE8E4FF);
    final rects = [
      Rect.fromLTWH(size.width * 0.05, size.height * 0.1, 60, 40),
      Rect.fromLTWH(size.width * 0.25, size.height * 0.5, 50, 55),
      Rect.fromLTWH(size.width * 0.55, size.height * 0.15, 70, 35),
      Rect.fromLTWH(size.width * 0.70, size.height * 0.55, 55, 45),
      Rect.fromLTWH(size.width * 0.38, size.height * 0.32, 45, 50),
    ];
    for (final r in rects) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(r, const Radius.circular(4)), blockPaint);
    }

    final roadPaint = Paint()
      ..color = const Color(0xFFCCC7FF)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, size.height * 0.38),
        Offset(size.width, size.height * 0.38), roadPaint);
    canvas.drawLine(Offset(size.width * 0.38, 0),
        Offset(size.width * 0.38, size.height), roadPaint);
    canvas.drawLine(Offset(size.width * 0.70, 0),
        Offset(size.width * 0.70, size.height), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.65),
        Offset(size.width, size.height * 0.65), roadPaint);

    final mainRoad = Paint()
      ..color = const Color(0xFFB8B0FF)
      ..strokeWidth = 3;
    canvas.drawLine(Offset(0, size.height * 0.20),
        Offset(size.width, size.height * 0.20), mainRoad);
    canvas.drawLine(Offset(size.width * 0.20, 0),
        Offset(size.width * 0.20, size.height), mainRoad);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
