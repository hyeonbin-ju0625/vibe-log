import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _ctrl = TextEditingController();
  int _selectedDays = 3;
  double _budget = 1000000;
  int? _selectedDest;

  // ── Design Tokens ──
  static const kBg      = Color(0xFF0A0A0F);
  static const kSurface = Color(0xFF141420);
  static const kBorder  = Color(0xFF2E2E45);
  static const kPrimary = Color(0xFF7B6EF6);
  static const kSecond  = Color(0xFFFF6B9D);
  static const kText    = Color(0xFFF0F0FF);
  static const kSub     = Color(0xFF8892A4);

  final _dests = const [
    {'name': '도쿄',  'icon': '🗼', 'c1': 0xFFFF6B9D, 'c2': 0xFFFF8E53},
    {'name': '파리',  'icon': '🥐', 'c1': 0xFF667EEA, 'c2': 0xFF764BA2},
    {'name': '발리',  'icon': '🌴', 'c1': 0xFF00D4AA, 'c2': 0xFF0085FF},
    {'name': '뉴욕',  'icon': '🗽', 'c1': 0xFF7B6EF6, 'c2': 0xFFFF6B9D},
    {'name': '방콕',  'icon': '🏯', 'c1': 0xFFFFBE0B, 'c2': 0xFFFF6B6B},
    {'name': '제주',  'icon': '🌊', 'c1': 0xFF0085FF, 'c2': 0xFF00D4AA},
  ];

  final _dayPresets = const [1, 2, 3, 5, 7];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topBar(),
                  _hero(),
                  _searchField(),
                  _quickDests(),
                  _durationSection(),
                  _budgetSection(),
                  _ctaButton(),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 상단 바 ──
  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [kPrimary, kSecond],
            ).createShader(b),
            child: Text('TR.',
                style: GoogleFonts.poppins(
                    fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
          ),
          _pill(
            child: Row(
              children: [
                Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [kPrimary, kSecond]),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 13),
                ),
                const SizedBox(width: 8),
                Text('AI 플래너',
                    style: GoogleFonts.poppins(
                        fontSize: 12, fontWeight: FontWeight.w600, color: kText)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 히어로 ──
  Widget _hero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '어디로\n떠나볼까요? ✈️',
            style: GoogleFonts.poppins(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: kText,
              height: 1.15,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'AI가 당신만의 완벽한 여행 일정을 만들어 드려요.',
            style: GoogleFonts.poppins(fontSize: 14, color: kSub, height: 1.6),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── 검색창 ──
  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: kBorder),
          boxShadow: [
            BoxShadow(
              color: kPrimary.withValues(alpha: 0.1),
              blurRadius: 24,
            ),
          ],
        ),
        child: TextField(
          controller: _ctrl,
          style: GoogleFonts.poppins(
              color: kText, fontSize: 15, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: '목적지를 입력하세요 ...',
            hintStyle: GoogleFonts.poppins(color: kSub, fontSize: 14),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [kPrimary, kSecond]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.search_rounded, color: Colors.white, size: 18),
              ),
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          ),
        ),
      ),
    );
  }

  // ── 인기 목적지 ──
  Widget _quickDests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('인기 여행지',
                  style: GoogleFonts.poppins(
                      fontSize: 17, fontWeight: FontWeight.w700, color: kText)),
              Text('전체보기',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: kPrimary, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        SizedBox(
          height: 148,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _dests.length,
            itemBuilder: (context, i) {
              final d = _dests[i];
              final sel = _selectedDest == i;
              final c1 = Color(d['c1'] as int);
              final c2 = Color(d['c2'] as int);
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedDest = i);
                  _ctrl.text = d['name'] as String;
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 110,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [c1, c2],
                    ),
                    borderRadius: BorderRadius.circular(22),
                    border: sel
                        ? Border.all(color: Colors.white, width: 2.5)
                        : Border.all(color: Colors.transparent, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: c1.withValues(alpha: sel ? 0.55 : 0.28),
                        blurRadius: sel ? 24 : 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(d['icon'] as String,
                          style: const TextStyle(fontSize: 38)),
                      const SizedBox(height: 10),
                      Text(d['name'] as String,
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── 기간 선택 ──
  Widget _durationSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('여행 기간',
                  style: GoogleFonts.poppins(
                      fontSize: 17, fontWeight: FontWeight.w700, color: kText)),
              Text('$_selectedDays박 ${_selectedDays + 1}일',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: kPrimary, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (int i = 0; i < _dayPresets.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(child: _dayPill(_dayPresets[i])),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _dayPill(int days) {
    final sel = _selectedDays == days;
    return GestureDetector(
      onTap: () => setState(() => _selectedDays = days),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: sel
              ? const LinearGradient(colors: [kPrimary, kSecond])
              : null,
          color: sel ? null : kSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: sel ? Colors.transparent : kBorder),
          boxShadow: sel
              ? [BoxShadow(
                  color: kPrimary.withValues(alpha: 0.4),
                  blurRadius: 14,
                  offset: const Offset(0, 4))]
              : null,
        ),
        child: Column(
          children: [
            Text('${days == 7 ? "7+" : days}박',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: sel ? Colors.white : kText)),
            Text('${days + 1}일',
                style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: sel ? Colors.white70 : kSub)),
          ],
        ),
      ),
    );
  }

  // ── 예산 슬라이더 ──
  Widget _budgetSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('예산',
                  style: GoogleFonts.poppins(
                      fontSize: 17, fontWeight: FontWeight.w700, color: kText)),
              _gradientChip('${(_budget / 10000).round()}만원'),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kBorder),
            ),
            child: Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    activeTrackColor: kPrimary,
                    inactiveTrackColor: kBorder,
                    thumbColor: Colors.white,
                    overlayColor: kPrimary.withValues(alpha: 0.15),
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 10),
                  ),
                  child: Slider(
                    value: _budget,
                    min: 100000,
                    max: 3000000,
                    divisions: 29,
                    onChanged: (v) => setState(() => _budget = v),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('10만원',
                        style: GoogleFonts.poppins(fontSize: 11, color: kSub)),
                    Text('300만원',
                        style: GoogleFonts.poppins(fontSize: 11, color: kSub)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── CTA 버튼 ──
  Widget _ctaButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/result', arguments: {
            'destination':
                _ctrl.text.isEmpty ? '목적지' : _ctrl.text,
            'days': _selectedDays,
            'budget': _budget.round(),
          });
        },
        child: Container(
          width: double.infinity,
          height: 62,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [kPrimary, kSecond],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: kPrimary.withValues(alpha: 0.5),
                blurRadius: 32,
                spreadRadius: 0,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_awesome_rounded,
                  color: Colors.white, size: 22),
              const SizedBox(width: 12),
              Text('AI 일정 생성하기',
                  style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3)),
            ],
          ),
        ),
      ),
    );
  }

  // ── 공통 위젯 ──
  Widget _pill({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorder),
      ),
      child: child,
    );
  }

  Widget _gradientChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [kPrimary, kSecond]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: GoogleFonts.poppins(
              fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
    );
  }
}
