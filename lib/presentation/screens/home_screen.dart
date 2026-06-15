import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/trip_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _ctrl = TextEditingController();
  int? _selectedDest;

  static const kBg      = Color(0xFFF6F7FF);
  static const kSurface = Color(0xFFFFFFFF);
  static const kBorder  = Color(0xFFE4E6F5);
  static const kPrimary = Color(0xFF7B6EF6);
  static const kSecond  = Color(0xFFFF6B9D);
  static const kText    = Color(0xFF1E1B4B);
  static const kSub     = Color(0xFF9496B0);

  final _dests = const [
    {'name': '도쿄',  'icon': '🗼', 'c1': 0xFFFF6B9D, 'c2': 0xFFFF8E53},
    {'name': '파리',  'icon': '🥐', 'c1': 0xFF667EEA, 'c2': 0xFF764BA2},
    {'name': '발리',  'icon': '🌴', 'c1': 0xFF00D4AA, 'c2': 0xFF0085FF},
    {'name': '뉴욕',  'icon': '🗽', 'c1': 0xFF7B6EF6, 'c2': 0xFFFF6B9D},
    {'name': '방콕',  'icon': '🏯', 'c1': 0xFFFFBE0B, 'c2': 0xFFFF6B6B},
    {'name': '제주',  'icon': '🌊', 'c1': 0xFF0085FF, 'c2': 0xFF00D4AA},
  ];

  final _dayPresets = const [1, 2, 3, 4];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _onGenerate() async {
    final dest = _ctrl.text.trim();
    if (dest.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('목적지를 입력해주세요',
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
          backgroundColor: kPrimary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final request = ref.read(tripRequestProvider);
    final confirmed = await _showConfirmDialog(dest, request.days, request.budget);
    if (!confirmed || !mounted) return;

    ref.read(tripRequestProvider.notifier).setDestination(dest);
    ref.read(tripPlanProvider.notifier).reset();
    await Navigator.pushNamed(context, '/result');
  }

  Future<bool> _showConfirmDialog(String dest, int days, int budget) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: kSurface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(color: kPrimary.withValues(alpha: 0.15),
                  blurRadius: 40, offset: const Offset(0, 16)),
            ],
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [kPrimary, kSecond]),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(
                      color: kPrimary.withValues(alpha: 0.35),
                      blurRadius: 20, offset: const Offset(0, 6))],
                ),
                child: const Icon(Icons.auto_awesome_rounded,
                    color: Colors.white, size: 26),
              ),
              const SizedBox(height: 20),
              Text('입력하신 정보가 맞나요?',
                  style: GoogleFonts.poppins(
                      fontSize: 17, fontWeight: FontWeight.w700, color: kText)),
              const SizedBox(height: 6),
              Text('아래 정보로 AI가 일정을 생성합니다',
                  style: GoogleFonts.poppins(fontSize: 12, color: kSub)),
              const SizedBox(height: 24),
              _confirmRow('📍', '목적지', dest),
              const SizedBox(height: 12),
              _confirmRow('📅', '기간', '$days박 ${days + 1}일'),
              const SizedBox(height: 12),
              _confirmRow('💰', '예산', '${(budget / 10000).round()}만원'),
              const SizedBox(height: 28),
              Row(children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(ctx, false),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F2FF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kBorder),
                      ),
                      child: Center(
                        child: Text('다시 입력',
                            style: GoogleFonts.poppins(
                                fontSize: 14, fontWeight: FontWeight.w600,
                                color: kSub)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(ctx, true),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [kPrimary, kSecond]),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(
                            color: kPrimary.withValues(alpha: 0.35),
                            blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: Center(
                        child: Text('맞아요!',
                            style: GoogleFonts.poppins(
                                fontSize: 14, fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    ) ?? false;
  }

  Widget _confirmRow(String emoji, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
      ),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Text(label,
            style: GoogleFonts.poppins(fontSize: 13, color: kSub,
                fontWeight: FontWeight.w500)),
        const Spacer(),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w700, color: kText)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = ref.watch(tripRequestProvider);
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
                  _durationSection(request.days),
                  _budgetSection(request.budget),
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
                    fontSize: 28, fontWeight: FontWeight.w800,
                    color: Colors.white)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: kPrimary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kPrimary.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [kPrimary, kSecond]),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome,
                      color: Colors.white, size: 13),
                ),
                const SizedBox(width: 8),
                Text('AI 플래너',
                    style: GoogleFonts.poppins(
                        fontSize: 12, fontWeight: FontWeight.w600,
                        color: kPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _hero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('어디로\n떠나볼까요? ✈️',
              style: GoogleFonts.poppins(
                  fontSize: 38, fontWeight: FontWeight.w800,
                  color: kText, height: 1.15, letterSpacing: -0.5)),
          const SizedBox(height: 12),
          Text('AI가 당신만의 완벽한 여행 일정을 만들어 드려요.',
              style: GoogleFonts.poppins(
                  fontSize: 14, color: kSub, height: 1.6)),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: kBorder),
          boxShadow: [
            BoxShadow(color: kPrimary.withValues(alpha: 0.08),
                blurRadius: 20, offset: const Offset(0, 4)),
          ],
        ),
        child: TextField(
          controller: _ctrl,
          onChanged: (v) =>
              ref.read(tripRequestProvider.notifier).setDestination(v),
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
                  gradient: const LinearGradient(
                      colors: [kPrimary, kSecond]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.search_rounded,
                    color: Colors.white, size: 18),
              ),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 18),
          ),
        ),
      ),
    );
  }

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
                      fontSize: 17, fontWeight: FontWeight.w700,
                      color: kText)),
              Text('전체보기',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: kPrimary,
                      fontWeight: FontWeight.w600)),
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
                  final name = d['name'] as String;
                  _ctrl.text = name;
                  ref.read(tripRequestProvider.notifier)
                      .setDestination(name);
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
                        : Border.all(
                            color: Colors.transparent, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: c1.withValues(
                            alpha: sel ? 0.5 : 0.22),
                        blurRadius: sel ? 20 : 10,
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
                              fontSize: 14, fontWeight: FontWeight.w700,
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

  Widget _durationSection(int selectedDays) {
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
                      fontSize: 17, fontWeight: FontWeight.w700,
                      color: kText)),
              Text('$selectedDays박 ${selectedDays + 1}일',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: kPrimary,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (int i = 0; i < _dayPresets.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(child: _dayPill(_dayPresets[i], selectedDays)),
              ],
              const SizedBox(width: 8),
              Expanded(child: _customDayPill(selectedDays)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dayPill(int days, int selectedDays) {
    final sel = selectedDays == days;
    return GestureDetector(
      onTap: () =>
          ref.read(tripRequestProvider.notifier).setDays(days),
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
              ? [BoxShadow(color: kPrimary.withValues(alpha: 0.35),
                  blurRadius: 12, offset: const Offset(0, 4))]
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Text('${days == 7 ? "7+" : days}박',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w700,
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

  Widget _customDayPill(int selectedDays) {
    final isCustom = !_dayPresets.contains(selectedDays);
    final sel = isCustom;
    return GestureDetector(
      onTap: () => _showCustomDayDialog(selectedDays),
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
              ? [BoxShadow(color: kPrimary.withValues(alpha: 0.35),
                  blurRadius: 12, offset: const Offset(0, 4))]
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Text(isCustom ? '$selectedDays박' : '7+',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w700,
                    color: sel ? Colors.white : kText)),
            Text(isCustom ? '${selectedDays + 1}일' : '직접',
                style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: sel ? Colors.white70 : kSub)),
          ],
        ),
      ),
    );
  }

  void _showCustomDayDialog(int currentDays) {
    final initVal = !_dayPresets.contains(currentDays) ? currentDays : 7;
    int tempDays = initVal;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          backgroundColor: kSurface,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24)),
          title: Text('기간 직접 설정',
              style: GoogleFonts.poppins(
                  fontSize: 17, fontWeight: FontWeight.w700,
                  color: kText)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('여행 기간을 선택하세요',
                  style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF9496B0))),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _stepperBtn(Icons.remove_rounded, () {
                    if (tempDays > 5) setDlg(() => tempDays--);
                  }),
                  const SizedBox(width: 24),
                  Column(
                    children: [
                      Text('$tempDays박',
                          style: GoogleFonts.poppins(
                              fontSize: 32, fontWeight: FontWeight.w800,
                              color: kPrimary)),
                      Text('${tempDays + 1}일',
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: const Color(0xFF9496B0))),
                    ],
                  ),
                  const SizedBox(width: 24),
                  _stepperBtn(Icons.add_rounded, () {
                    if (tempDays < 30) setDlg(() => tempDays++);
                  }),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('취소',
                  style: GoogleFonts.poppins(
                      color: const Color(0xFF9496B0), fontWeight: FontWeight.w600)),
            ),
            TextButton(
              onPressed: () {
                ref.read(tripRequestProvider.notifier).setDays(tempDays);
                Navigator.pop(ctx);
              },
              child: Text('확인',
                  style: GoogleFonts.poppins(
                      color: kPrimary, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepperBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: kPrimary.withValues(alpha: 0.08),
          shape: BoxShape.circle,
          border: Border.all(color: kPrimary.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: kPrimary, size: 20),
      ),
    );
  }

  Widget _budgetSection(int budget) {
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
                      fontSize: 17, fontWeight: FontWeight.w700,
                      color: kText)),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [kPrimary, kSecond]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${(budget / 10000).round()}만원',
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kBorder),
              boxShadow: [BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    activeTrackColor: kPrimary,
                    inactiveTrackColor: kBorder,
                    thumbColor: Colors.white,
                    overlayColor: kPrimary.withValues(alpha: 0.12),
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 10),
                  ),
                  child: Slider(
                    value: budget.toDouble(),
                    min: 100000,
                    max: 3000000,
                    divisions: 29,
                    onChanged: (v) => ref
                        .read(tripRequestProvider.notifier)
                        .setBudget(v.round()),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('10만원',
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: kSub)),
                    Text('300만원',
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: kSub)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ctaButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 0),
      child: GestureDetector(
        onTap: _onGenerate,
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
                color: kPrimary.withValues(alpha: 0.4),
                blurRadius: 28,
                offset: const Offset(0, 10),
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
                      fontSize: 17, fontWeight: FontWeight.w700,
                      color: Colors.white, letterSpacing: 0.3)),
            ],
          ),
        ),
      ),
    );
  }
}
