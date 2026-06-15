import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/trip_provider.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  static const kBg      = Color(0xFFF6F7FF);
  static const kSurface = Color(0xFFFFFFFF);
  static const kCard    = Color(0xFFF0F2FF);
  static const kBorder  = Color(0xFFE4E6F5);
  static const kPrimary = Color(0xFF7B6EF6);
  static const kSecond  = Color(0xFFFF6B9D);
  static const kMint    = Color(0xFF00C49A);
  static const kGold    = Color(0xFFFFBE0B);
  static const kText    = Color(0xFF1E1B4B);
  static const kSub     = Color(0xFF9496B0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  _heroBanner(ref),
                  _sectionHeader('🔥  지금 뜨는 여행지', '전체보기'),
                  _trendingScroll(),
                  _sectionHeader('🌸  계절 추천', null),
                  _seasonalScroll(),
                  _sectionHeader('✨  인기 테마', null),
                  _themeGrid(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [kPrimary, kSecond],
                  ).createShader(b),
                  child: Text('TR.',
                      style: GoogleFonts.poppins(
                          fontSize: 30, fontWeight: FontWeight.w800,
                          color: Colors.white, letterSpacing: -0.5)),
                ),
                Text('어디로 떠날까요?',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: kSub, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kBorder),
              boxShadow: [BoxShadow(color: kPrimary.withValues(alpha: 0.06),
                  blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: const Icon(Icons.search_rounded, color: kSub, size: 20),
          ),
          const SizedBox(width: 10),
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kBorder),
              boxShadow: [BoxShadow(color: kPrimary.withValues(alpha: 0.06),
                  blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Stack(
              children: [
                const Center(child: Icon(Icons.notifications_outlined, color: kSub, size: 20)),
                Positioned(
                  top: 9, right: 9,
                  child: Container(
                    width: 7, height: 7,
                    decoration: const BoxDecoration(color: kSecond, shape: BoxShape.circle),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroBanner(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Container(
        height: 196,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6C5CE7), Color(0xFFa855f7)],
          ),
          boxShadow: [
            BoxShadow(
              color: kPrimary.withValues(alpha: 0.35),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.antiAlias,
          children: [
            Positioned(
              left: -30, bottom: -30,
              child: Container(
                width: 160, height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    Colors.white.withValues(alpha: 0.15),
                    Colors.white.withValues(alpha: 0.0),
                  ]),
                ),
              ),
            ),
            Positioned(
              right: -20, top: -20,
              child: Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    Colors.white.withValues(alpha: 0.12),
                    Colors.white.withValues(alpha: 0.0),
                  ]),
                ),
              ),
            ),
            Positioned(
              right: 24, bottom: 16,
              child: Text('✈️',
                  style: TextStyle(fontSize: 72,
                      color: Colors.white.withValues(alpha: 0.15))),
            ),
            Padding(
              padding: const EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(width: 6, height: 6,
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text('AI 여행 플래너',
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: Colors.white,
                              fontWeight: FontWeight.w700)),
                    ]),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('완벽한 여행 일정,\n지금 바로 만들어보세요',
                          style: GoogleFonts.poppins(
                              fontSize: 19, fontWeight: FontWeight.w800,
                              color: Colors.white, height: 1.35)),
                      const SizedBox(height: 14),
                      GestureDetector(
                        onTap: () => ref.read(tabIndexProvider.notifier).setTab(1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 12, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.auto_awesome_rounded,
                                color: kPrimary, size: 14),
                            const SizedBox(width: 7),
                            Text('일정 만들기',
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.w700,
                                    color: kPrimary)),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward_rounded,
                                color: kPrimary, size: 13),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String? action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 17, fontWeight: FontWeight.w700, color: kText)),
          if (action != null)
            Text(action,
                style: GoogleFonts.poppins(
                    fontSize: 12, color: kPrimary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _trendingScroll() {
    final items = [
      _TrendItem('도쿄',  '🗼', '일본',       '4.9', [0xFFFF6B9D, 0xFFFF8E53], '봄 벚꽃 시즌'),
      _TrendItem('파리',  '🥐', '프랑스',     '4.8', [0xFF667EEA, 0xFF764BA2], '낭만 가득'),
      _TrendItem('발리',  '🌴', '인도네시아', '4.7', [0xFF00D4AA, 0xFF0085FF], '힐링 여행'),
      _TrendItem('뉴욕',  '🗽', '미국',       '4.8', [0xFF7B6EF6, 0xFFFF6B9D], '도시 탐방'),
      _TrendItem('방콕',  '🏯', '태국',       '4.6', [0xFFFFBE0B, 0xFFFF6B6B], '야시장 필수'),
      _TrendItem('제주',  '🌊', '한국',       '4.9', [0xFF0085FF, 0xFF00D4AA], '국내 힐링'),
    ];
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        itemBuilder: (_, i) => _trendCard(items[i]),
      ),
    );
  }

  Widget _trendCard(_TrendItem item) {
    final c1 = Color(item.colors[0]);
    final c2 = Color(item.colors[1]);
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [c1, c2],
        ),
        boxShadow: [
          BoxShadow(color: c1.withValues(alpha: 0.3),
              blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20, right: -20,
            child: Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.0),
                ]),
              ),
            ),
          ),
          Positioned(
            top: 12, right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.star_rounded, color: kGold, size: 11),
                const SizedBox(width: 3),
                Text(item.rating,
                    style: GoogleFonts.poppins(
                        fontSize: 10, color: Colors.white,
                        fontWeight: FontWeight.w700)),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(item.emoji, style: const TextStyle(fontSize: 40)),
                const SizedBox(height: 8),
                Text(item.name,
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w800,
                        color: Colors.white, letterSpacing: -0.3)),
                Text(item.country,
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.8))),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(item.tag,
                      style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _seasonalScroll() {
    final items = [
      _SeasonItem('봄 벚꽃',   '🌸', '도쿄 · 경주 · 제주',        [0xFFFF6B9D, 0xFFFF8E53]),
      _SeasonItem('여름 바다', '☀️', '발리 · 푸켓 · 오키나와',     [0xFF00D4AA, 0xFF0085FF]),
      _SeasonItem('가을 단풍', '🍁', '교토 · 설악산 · 캐나다',     [0xFFFFBE0B, 0xFFFF6B6B]),
      _SeasonItem('겨울 설경', '❄️', '홋카이도 · 스위스 · 강원도', [0xFF667EEA, 0xFF764BA2]),
    ];
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i];
          final c1 = Color(item.colors[0]);
          final c2 = Color(item.colors[1]);
          return Container(
            width: 210,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kBorder),
              boxShadow: [
                BoxShadow(color: kPrimary.withValues(alpha: 0.06),
                    blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(children: [
              Container(
                width: 54, height: 54,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [c1, c2],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: c1.withValues(alpha: 0.3),
                      blurRadius: 10, offset: const Offset(0, 3))],
                ),
                child: Center(child: Text(item.emoji,
                    style: const TextStyle(fontSize: 26))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.season,
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w700,
                            color: kText)),
                    const SizedBox(height: 5),
                    Text(item.places,
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: kSub, height: 1.4),
                        overflow: TextOverflow.ellipsis, maxLines: 2),
                  ],
                ),
              ),
            ]),
          );
        },
      ),
    );
  }

  Widget _themeGrid() {
    final themes = [
      ('🍜', '맛집 투어',   '미식 여행의 정석', 0xFF7B6EF6),
      ('🌿', '자연 힐링',   '지친 일상 탈출',   0xFF00C49A),
      ('🏛️', '문화 탐방',  '역사 속으로',      0xFF0085FF),
      ('🛍️', '쇼핑',       '득템의 즐거움',    0xFFFF6B9D),
      ('📸', '인스타 성지', '인생샷 건지기',    0xFFFF8E53),
      ('🎭', '현지 체험',   '로컬처럼 즐기기',  0xFFFFBE0B),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.6,
        children: themes.map((t) {
          final c = Color(t.$4);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: kBorder),
              boxShadow: [BoxShadow(color: c.withValues(alpha: 0.08),
                  blurRadius: 10, offset: const Offset(0, 3))],
            ),
            child: Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: c.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: Text(t.$1,
                    style: const TextStyle(fontSize: 18))),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(t.$2,
                        style: GoogleFonts.poppins(
                            fontSize: 12, fontWeight: FontWeight.w700,
                            color: kText)),
                    Text(t.$3,
                        style: GoogleFonts.poppins(fontSize: 10, color: kSub),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ]),
          );
        }).toList(),
      ),
    );
  }
}

class _TrendItem {
  final String name, emoji, country, rating, tag;
  final List<int> colors;
  const _TrendItem(this.name, this.emoji, this.country, this.rating,
      this.colors, this.tag);
}

class _SeasonItem {
  final String season, emoji, places;
  final List<int> colors;
  const _SeasonItem(this.season, this.emoji, this.places, this.colors);
}
