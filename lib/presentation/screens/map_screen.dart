import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int _filter = 0;

  static const kBg      = Color(0xFF0A0A0F);
  static const kSurface = Color(0xFF141420);
  static const kBorder  = Color(0xFF2E2E45);
  static const kPrimary = Color(0xFF7B6EF6);
  static const kSecond  = Color(0xFFFF6B9D);
  static const kText    = Color(0xFFF0F0FF);
  static const kSub     = Color(0xFF8892A4);

  final List<Map<String, dynamic>> _locs = const [
    {'name':'호텔 체크인',   'addr':'시내 중심가',    'day':1,'icon':'🏨','c':0xFF7B6EF6,'fx':0.18,'fy':0.30},
    {'name':'현지 맛집',     'addr':'번화가 골목',    'day':1,'icon':'🍜','c':0xFFFF6B9D,'fx':0.48,'fy':0.18},
    {'name':'주요 관광지',   'addr':'도심 관광 명소', 'day':1,'icon':'🏛️','c':0xFF00D4AA,'fx':0.74,'fy':0.42},
    {'name':'로컬 시장',     'addr':'전통 재래시장',  'day':2,'icon':'🛒','c':0xFFFFBE0B,'fx':0.28,'fy':0.62},
    {'name':'박물관',        'addr':'문화 구역',      'day':2,'icon':'🎨','c':0xFFFF8E53,'fx':0.60,'fy':0.72},
    {'name':'야경 명소',     'addr':'전망대',         'day':2,'icon':'🌆','c':0xFF0085FF,'fx':0.84,'fy':0.24},
  ];

  List<Map<String, dynamic>> get _filtered =>
      _filter == 0 ? _locs : _locs.where((e) => e['day'] == _filter).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          _header(context),
          _mapArea(),
          _filterRow(),
          Expanded(child: _locationList()),
        ],
      ),
    );
  }

  // ── 헤더 ──
  Widget _header(BuildContext ctx) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1040), Color(0xFF0D0D1E)],
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
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 18),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('📍  지도로 보기',
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w800, color: kText)),
                Text('일정 장소를 한눈에 확인하세요',
                    style: GoogleFonts.poppins(fontSize: 12, color: kSub)),
              ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: kPrimary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kPrimary.withValues(alpha: 0.3)),
              ),
              child: Text('${_locs.length}개 장소',
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.w600, color: kPrimary)),
            ),
          ]),
        ),
      ),
    );
  }

  // ── 지도 영역 ──
  Widget _mapArea() {
    return Container(
      height: 230,
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          const h = 230.0;
          return Stack(
            children: [
              // 다크 맵 배경
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0D1117), Color(0xFF131825)],
                  ),
                ),
              ),
              // 그리드 페인터
              CustomPaint(
                size: Size(w, h),
                painter: _DarkMapPainter(),
              ),
              // 핀들
              for (final loc in _filtered)
                Positioned(
                  left: (loc['fx'] as double) * w - 14,
                  top:  (loc['fy'] as double) * h - 20,
                  child: _pin(loc),
                ),
              // 중앙 배지
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E30).withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [kPrimary, kSecond]),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.map_rounded,
                          color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 10),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Google Maps 연동 예정',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700, fontSize: 13,
                              color: kText)),
                      Text('API 키 설정 후 실제 지도 표시',
                          style: GoogleFonts.poppins(
                              fontSize: 10, color: kSub)),
                    ]),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _pin(Map<String, dynamic> loc) {
    final c = Color(loc['c'] as int);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30, height: 30,
          decoration: BoxDecoration(
            color: c,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(color: c.withValues(alpha: 0.6), blurRadius: 10),
            ],
          ),
          child: Center(
            child: Text(loc['icon'] as String,
                style: const TextStyle(fontSize: 14)),
          ),
        ),
        Container(
            width: 2, height: 6,
            color: c),
        Container(
            width: 5, height: 5,
            decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
      ],
    );
  }

  // ── 필터 ──
  Widget _filterRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
      child: Row(children: [
        _filterChip('전체', 0),
        const SizedBox(width: 8),
        _filterChip('Day 1', 1),
        const SizedBox(width: 8),
        _filterChip('Day 2', 2),
      ]),
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
              ? [BoxShadow(color: kPrimary.withValues(alpha: 0.4),
                  blurRadius: 12, offset: const Offset(0, 4))]
              : null,
        ),
        child: Text(label,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                color: sel ? Colors.white : kSub)),
      ),
    );
  }

  // ── 장소 목록 ──
  Widget _locationList() {
    final items = _filtered;
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final loc = items[i];
        final c   = Color(loc['c'] as int);
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: kSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: kBorder),
            boxShadow: [
              BoxShadow(
                color: c.withValues(alpha: 0.07),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(children: [
            // 아이콘 박스
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: c.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: c.withValues(alpha: 0.3)),
              ),
              child: Center(
                child: Text(loc['icon'] as String,
                    style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 14),
            // 텍스트
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc['name'] as String,
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w700,
                          color: kText)),
                  const SizedBox(height: 3),
                  Text(loc['addr'] as String,
                      style: GoogleFonts.poppins(fontSize: 12, color: kSub)),
                ],
              ),
            ),
            // Day 배지
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: c.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: c.withValues(alpha: 0.3)),
              ),
              child: Text('Day ${loc['day']}',
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

// ── 다크 맵 그리드 페인터 ──
class _DarkMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 미세 격자
    final gridPaint = Paint()
      ..color = const Color(0xFF1A2030)
      ..strokeWidth = 0.8;
    for (double y = 0; y < size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    for (double x = 0; x < size.width; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // 블록 (건물 느낌)
    final blockPaint = Paint()..color = const Color(0xFF111820);
    final rects = [
      Rect.fromLTWH(size.width*0.05, size.height*0.1, 60, 40),
      Rect.fromLTWH(size.width*0.25, size.height*0.5, 50, 55),
      Rect.fromLTWH(size.width*0.55, size.height*0.15, 70, 35),
      Rect.fromLTWH(size.width*0.70, size.height*0.55, 55, 45),
      Rect.fromLTWH(size.width*0.38, size.height*0.32, 45, 50),
    ];
    for (final r in rects) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(r, const Radius.circular(4)), blockPaint);
    }

    // 도로 (굵은 선)
    final roadPaint = Paint()
      ..color = const Color(0xFF1E2A40)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, size.height*0.38),
        Offset(size.width, size.height*0.38), roadPaint);
    canvas.drawLine(Offset(size.width*0.38, 0),
        Offset(size.width*0.38, size.height), roadPaint);
    canvas.drawLine(Offset(size.width*0.70, 0),
        Offset(size.width*0.70, size.height), roadPaint);
    canvas.drawLine(Offset(0, size.height*0.65),
        Offset(size.width, size.height*0.65), roadPaint);

    // 주요 도로 (더 밝게)
    final mainRoad = Paint()
      ..color = const Color(0xFF253040)
      ..strokeWidth = 3;
    canvas.drawLine(Offset(0, size.height*0.20),
        Offset(size.width, size.height*0.20), mainRoad);
    canvas.drawLine(Offset(size.width*0.20, 0),
        Offset(size.width*0.20, size.height), mainRoad);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
