import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/trip_provider.dart';
import '../../data/models/place.dart';
import '../../data/models/trip_plan.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});
  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen>
    with SingleTickerProviderStateMixin {
  static const kBg      = Color(0xFFF6F7FF);
  static const kSurface = Color(0xFFFFFFFF);
  static const kCard    = Color(0xFFF0F2FF);
  static const kBorder  = Color(0xFFE4E6F5);
  static const kPrimary = Color(0xFF7B6EF6);
  static const kSecond  = Color(0xFFFF6B9D);
  static const kGold    = Color(0xFFFFBE0B);
  static const kText    = Color(0xFF1E1B4B);
  static const kSub     = Color(0xFF9496B0);

  late final AnimationController _gaugeCtrl;
  late final Animation<double> _gaugeAnim;
  bool _gaugeComplete = false;

  @override
  void initState() {
    super.initState();

    _gaugeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    _gaugeAnim = CurvedAnimation(
      parent: _gaugeCtrl,
      curve: Curves.easeInOut,
    );
    _gaugeCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _gaugeComplete = true);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final planState = ref.read(tripPlanProvider);
      if (planState is TripPlanSuccess) {
        // 이미 결과 있음 (내 여행에서 진입) → 게이지 스킵
        setState(() => _gaugeComplete = true);
      } else {
        // 새로 생성 → 게이지 시작
        _gaugeCtrl.forward();
        if (planState is TripPlanIdle) {
          final request = ref.read(tripRequestProvider);
          ref.read(tripPlanProvider.notifier).generate(request);
        }
      }
    });
  }

  @override
  void dispose() {
    _gaugeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final planState = ref.watch(tripPlanProvider);

    // 게이지가 아직 채워지는 중 → 무조건 로딩 화면
    if (!_gaugeComplete) return _buildLoading();

    // 게이지 완료 후 상태에 따라 전환
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: switch (planState) {
        TripPlanSuccess(:final plan) => _buildResult(plan),
        TripPlanError(:final message) => _buildError(message),
        _ => _buildLoading(), // 게이지 끝났지만 API 아직 대기 중 (드문 경우)
      },
    );
  }

  Widget _buildLoading() {
    final request = ref.watch(tripRequestProvider);
    final dest = request.destination.isEmpty ? '여행지' : request.destination;
    return Scaffold(
      backgroundColor: kBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 원형 게이지 + 로고
            AnimatedBuilder(
              animation: _gaugeAnim,
              builder: (_, __) => SizedBox(
                width: 116, height: 116,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 배경 트랙
                    SizedBox(
                      width: 116, height: 116,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 5,
                        color: kBorder,
                      ),
                    ),
                    // 채워지는 게이지
                    SizedBox(
                      width: 116, height: 116,
                      child: CircularProgressIndicator(
                        value: _gaugeAnim.value,
                        strokeWidth: 5,
                        strokeCap: StrokeCap.round,
                        valueColor: AlwaysStoppedAnimation(
                          Color.lerp(kPrimary, kSecond, _gaugeAnim.value)!,
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    // 로고
                    Container(
                      width: 88, height: 88,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [kPrimary, kSecond]),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(
                            color: kPrimary.withValues(alpha: 0.4),
                            blurRadius: 28, spreadRadius: 2)],
                      ),
                      child: const Icon(Icons.auto_awesome_rounded,
                          color: Colors.white, size: 38),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 36),
            Text('AI가 일정을 만드는 중...',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w700, color: kText)),
            const SizedBox(height: 10),
            Text('$dest ${request.days}박 ${request.days + 1}일 코스',
                style: GoogleFonts.poppins(fontSize: 14, color: kSub)),
            const SizedBox(height: 16),
            // 게이지 퍼센트 텍스트
            AnimatedBuilder(
              animation: _gaugeAnim,
              builder: (_, __) => Text(
                '${(_gaugeAnim.value * 100).toInt()}%',
                style: GoogleFonts.poppins(
                    fontSize: 13, fontWeight: FontWeight.w600,
                    color: kPrimary),
              ),
            ),
            const SizedBox(height: 20),
            Text('최적의 동선과 장소를 분석하고 있어요',
                style: GoogleFonts.poppins(fontSize: 12, color: kSub)),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Scaffold(
      backgroundColor: kBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: kSecond, size: 56),
            const SizedBox(height: 16),
            Text('일정 생성에 실패했어요',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w700, color: kText)),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320, maxHeight: 120),
              child: SingleChildScrollView(
                child: Text(message,
                    style: GoogleFonts.poppins(fontSize: 13, color: kSub),
                    textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                final request = ref.read(tripRequestProvider);
                ref.read(tripPlanProvider.notifier).generate(request);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [kPrimary, kSecond]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(
                      color: kPrimary.withValues(alpha: 0.4),
                      blurRadius: 20, offset: const Offset(0, 6))],
                ),
                child: Text('다시 시도',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.w700,
                        fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(TripPlan plan) {
    final selectedDay = ref.watch(selectedDayProvider);
    final places = plan.placesForDay(selectedDay);
    return Scaffold(
      backgroundColor: kBg,
      body: Column(children: [
        _header(plan),
        _dayTabs(plan),
        _mapArea(plan.placesForDay(selectedDay)),
        Expanded(child: _timeline(places)),
      ]),
    );
  }

  Widget _mapArea(List<Place> locs) {
    final valid = locs
        .where((p) => p.lat != null && p.lng != null && p.lat != 0 && p.lng != 0)
        .toList();

    if (valid.isEmpty) {
      return Container(
        height: 220,
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEBFF),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: Text('지도 정보를 불러올 수 없어요',
              style: GoogleFonts.poppins(fontSize: 13, color: kSub)),
        ),
      );
    }

    final avgLat = valid.map((p) => p.lat!).reduce((a, b) => a + b) / valid.length;
    final avgLng = valid.map((p) => p.lng!).reduce((a, b) => a + b) / valid.length;

    final markers = valid.map((p) => Marker(
      markerId: MarkerId(p.name),
      position: LatLng(p.lat!, p.lng!),
      infoWindow: InfoWindow(title: p.name, snippet: p.time),
    )).toSet();

    return Container(
      height: 220,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(
            color: kPrimary.withValues(alpha: 0.10),
            blurRadius: 16, offset: const Offset(0, 4))],
      ),
      clipBehavior: Clip.antiAlias,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(avgLat, avgLng),
          zoom: 13,
        ),
        markers: markers,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        mapToolbarEnabled: false,
      ),
    );
  }

  Widget _header(TripPlan plan) {
    final req = plan.request;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7B6EF6), Color(0xFFa855f7)],
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
                _backBtn(),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(req.destination,
                        style: GoogleFonts.poppins(
                            fontSize: 22, fontWeight: FontWeight.w800,
                            color: Colors.white)),
                    Text(plan.summary,
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.75)),
                        overflow: TextOverflow.ellipsis),
                  ]),
                ),
              ]),
              const SizedBox(height: 20),
              Row(children: [
                _statBadge(Icons.calendar_today_rounded,
                    '${req.days}박 ${req.days + 1}일'),
                const SizedBox(width: 10),
                _statBadge(Icons.wallet_rounded,
                    '${(req.budget / 10000).round()}만원'),
                const SizedBox(width: 10),
                _statBadge(Icons.place_rounded,
                    '${plan.places.length}개 장소'),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backBtn() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 42, height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.white, size: 18),
      ),
    );
  }

  Widget _statBadge(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: Colors.white.withValues(alpha: 0.25)),
        ),
        child: Row(children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 11, fontWeight: FontWeight.w600,
                    color: Colors.white),
                overflow: TextOverflow.ellipsis),
          ),
        ]),
      ),
    );
  }

  Widget _dayTabs(TripPlan plan) {
    final selected = ref.watch(selectedDayProvider);
    final totalDays = plan.totalDays;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          _tab('전체', 0, selected),
          for (int d = 1; d <= totalDays; d++) ...[
            const SizedBox(width: 8),
            _tab('Day $d', d, selected),
          ],
        ]),
      ),
    );
  }

  Widget _tab(String label, int val, int selected) {
    final sel = selected == val;
    return GestureDetector(
      onTap: () => ref.read(selectedDayProvider.notifier).select(val),
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
              ? [BoxShadow(color: kPrimary.withValues(alpha: 0.35),
                  blurRadius: 12, offset: const Offset(0, 4))]
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

  Widget _timeline(List<Place> places) {
    if (places.isEmpty) {
      return Center(child: Text('장소가 없어요',
          style: GoogleFonts.poppins(color: kSub, fontSize: 14)));
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      itemCount: places.length,
      itemBuilder: (context, i) {
        final place  = places[i];
        final isLast = i == places.length - 1;
        final isNewDay = i == 0 || places[i - 1].day != place.day;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isNewDay) _dayLabel(place.day),
            _timelineRow(place, isLast),
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
          gradient: const LinearGradient(
              colors: [kSecond, kGold]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: kSecond.withValues(alpha: 0.3),
              blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Text('Day $day',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w700,
                fontSize: 12, letterSpacing: 0.5)),
      ),
    );
  }

  Widget _timelineRow(Place place, bool isLast) {
    final cc = place.color;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Column(children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: cc.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: cc.withValues(alpha: 0.35), width: 1.5),
                ),
                child: Center(child: Text(place.emoji,
                    style: const TextStyle(fontSize: 18))),
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
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: kSurface,
                borderRadius: BorderRadius.circular(18),
                border: Border(left: BorderSide(color: cc, width: 3)),
                boxShadow: [BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12, offset: const Offset(0, 3))],
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
                          child: Text(place.name,
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
                          child: Text(place.time,
                              style: GoogleFonts.poppins(
                                  fontSize: 11, fontWeight: FontWeight.w600,
                                  color: kPrimary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(place.description,
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: kSub, height: 1.55)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: cc.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(place.category.label,
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

}

