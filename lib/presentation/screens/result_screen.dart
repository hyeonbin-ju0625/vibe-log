import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int _selectedDay = 0;

  static const kBg      = Color(0xFF0A0A0F);
  static const kSurface = Color(0xFF141420);
  static const kCard    = Color(0xFF1E1E30);
  static const kBorder  = Color(0xFF2E2E45);
  static const kPrimary = Color(0xFF7B6EF6);
  static const kSecond  = Color(0xFFFF6B9D);
  static const kMint    = Color(0xFF00D4AA);
  static const kGold    = Color(0xFFFFBE0B);
  static const kText    = Color(0xFFF0F0FF);
  static const kSub     = Color(0xFF8892A4);

  final List<Map<String, dynamic>> _plan = const [
    {'day':1,'time':'09:00','place':'도착 & 호텔 체크인','desc':'짐을 풀고 루프탑 카페에서 여유롭게 휴식','icon':'🏨','cat':'숙소','cc':0xFF7B6EF6},
    {'day':1,'time':'12:00','place':'현지 맛집 점심','desc':'구글 평점 4.5 이상의 현지 인기 식당 탐방','icon':'🍜','cat':'식사','cc':0xFFFF6B9D},
    {'day':1,'time':'14:30','place':'주요 관광지 방문','desc':'도시를 대표하는 명소를 여유롭게 탐방','icon':'🏛️','cat':'관광','cc':0xFF00D4AA},
    {'day':1,'time':'19:00','place':'루프탑 저녁 식사','desc':'야경을 감상하며 분위기 좋은 레스토랑 디너','icon':'🍽️','cat':'식사','cc':0xFFFF6B9D},
    {'day':2,'time':'09:00','place':'로컬 시장 투어','desc':'이른 아침 현지 재래시장에서 현지인처럼','icon':'🛒','cat':'체험','cc':0xFFFFBE0B},
    {'day':2,'time':'13:00','place':'박물관 / 미술관','desc':'현지 역사와 문화를 감각 있게 탐방','icon':'🎨','cat':'문화','cc':0xFFFF8E53},
    {'day':2,'time':'18:30','place':'야경 명소 & 선셋','desc':'전망대에서 황금빛 노을과 화려한 야경 감상','icon':'🌆','cat':'관광','cc':0xFF00D4AA},
  ];

  List<Map<String, dynamic>> get _filtered =>
      _selectedDay == 0 ? _plan : _plan.where((e) => e['day'] == _selectedDay).toList();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final dest   = (args['destination'] ?? '목적지') as String;
    final days   = (args['days'] ?? 3) as int;
    final budget = (args['budget'] ?? 500000) as int;

    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          _header(context, dest, days, budget),
          _dayTabs(),
          Expanded(child: _timeline()),
        ],
      ),
      floatingActionButton: _fab(context),
    );
  }

  // ── 헤더 ──
  Widget _header(BuildContext ctx, String dest, int days, int budget) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1040), Color(0xFF0D0D1E)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                _backBtn(ctx),
                const SizedBox(width: 14),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(dest,
                      style: GoogleFonts.poppins(
                          fontSize: 22, fontWeight: FontWeight.w800, color: kText)),
                  Text('여행 일정',
                      style: GoogleFonts.poppins(fontSize: 13, color: kSub)),
                ]),
              ]),
              const SizedBox(height: 20),
              Row(children: [
                _statBadge(Icons.calendar_today_rounded, '$days박 ${days+1}일', kPrimary),
                const SizedBox(width: 10),
                _statBadge(Icons.wallet_rounded, '${(budget/10000).round()}만원', kSecond),
                const SizedBox(width: 10),
                _statBadge(Icons.place_rounded, '${_plan.length}개 장소', kMint),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backBtn(BuildContext ctx) {
    return GestureDetector(
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
    );
  }

  Widget _statBadge(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 6),
          Expanded(
            child: Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w600, color: kText),
                overflow: TextOverflow.ellipsis),
          ),
        ]),
      ),
    );
  }

  // ── 날짜 탭 ──
  Widget _dayTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Row(children: [
        _tab('전체', 0),
        const SizedBox(width: 8),
        _tab('Day 1', 1),
        const SizedBox(width: 8),
        _tab('Day 2', 2),
      ]),
    );
  }

  Widget _tab(String label, int val) {
    final sel = _selectedDay == val;
    return GestureDetector(
      onTap: () => setState(() => _selectedDay = val),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          gradient: sel
              ? const LinearGradient(colors: [kPrimary, kSecond])
              : null,
          color: sel ? null : kSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: sel ? Colors.transparent : kBorder),
          boxShadow: sel
              ? [BoxShadow(color: kPrimary.withValues(alpha: 0.4),
                  blurRadius: 14, offset: const Offset(0, 4))]
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

  // ── 타임라인 ──
  Widget _timeline() {
    final items = _filtered;
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item     = items[i];
        final isLast   = i == items.length - 1;
        final isNewDay = i == 0 || items[i - 1]['day'] != item['day'];
        final cc       = Color(item['cc'] as int);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isNewDay) _dayLabel(item['day'] as int),
            _timelineRow(item, isLast, cc),
          ],
        );
      },
    );
  }

  Widget _dayLabel(int day) {
    return Padding(
      padding: const EdgeInsets.only(left: 52, bottom: 12, top: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [kSecond, kGold]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: kSecond.withValues(alpha: 0.35),
                blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Text('Day $day',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w700,
                fontSize: 12, letterSpacing: 0.5)),
      ),
    );
  }

  Widget _timelineRow(Map<String, dynamic> item, bool isLast, Color cc) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아이콘 + 선
          SizedBox(
            width: 40,
            child: Column(children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: cc.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: cc.withValues(alpha: 0.45), width: 1.5),
                ),
                child: Center(
                  child: Text(item['icon'] as String,
                      style: const TextStyle(fontSize: 18)),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: kBorder,
                  ),
                ),
            ]),
          ),
          const SizedBox(width: 14),
          // 카드
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: kSurface,
                borderRadius: BorderRadius.circular(18),
                border: Border(left: BorderSide(color: cc, width: 3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(item['place'] as String,
                              style: GoogleFonts.poppins(
                                  fontSize: 15, fontWeight: FontWeight.w700,
                                  color: kText)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: kCard,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: kBorder),
                          ),
                          child: Text(item['time'] as String,
                              style: GoogleFonts.poppins(
                                  fontSize: 11, fontWeight: FontWeight.w600,
                                  color: kPrimary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(item['desc'] as String,
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: kSub, height: 1.55)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: cc.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(item['cat'] as String,
                          style: GoogleFonts.poppins(
                              fontSize: 11, fontWeight: FontWeight.w600,
                              color: cc)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── FAB ──
  Widget _fab(BuildContext ctx) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(ctx, '/map'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [kPrimary, kSecond]),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: kPrimary.withValues(alpha: 0.5),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.map_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('지도로 보기',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w700,
                    fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
