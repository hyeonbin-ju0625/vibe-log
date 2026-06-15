import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/trip_request.dart';
import '../../data/models/trip_plan.dart';
import '../../data/repositories/trip_repository.dart';
import 'api_key_provider.dart';

// ── 현재 탭 인덱스 ─────────────────────────────────────

class TabIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void setTab(int index) => state = index;
}

final tabIndexProvider =
    NotifierProvider<TabIndexNotifier, int>(TabIndexNotifier.new);

// ── 리포지토리 ──────────────────────────────────────────

final tripRepositoryProvider = Provider<TripRepository>(
  (ref) => TripRepository(),
);

// ── 현재 여행 요청 상태 ─────────────────────────────────

class TripRequestNotifier extends Notifier<TripRequest> {
  @override
  TripRequest build() => const TripRequest(
        destination: '',
        days: 3,
        budget: 1000000,
      );

  void setDestination(String v) => state = state.copyWith(destination: v);
  void setDays(int v)           => state = state.copyWith(days: v);
  void setBudget(int v)         => state = state.copyWith(budget: v);
}

final tripRequestProvider =
    NotifierProvider<TripRequestNotifier, TripRequest>(TripRequestNotifier.new);

// ── 생성된 여행 일정 상태 ───────────────────────────────

sealed class TripPlanState {
  const TripPlanState();
}

class TripPlanIdle    extends TripPlanState { const TripPlanIdle(); }
class TripPlanLoading extends TripPlanState { const TripPlanLoading(); }
class TripPlanSuccess extends TripPlanState {
  final TripPlan plan;
  const TripPlanSuccess(this.plan);
}
class TripPlanError extends TripPlanState {
  final String message;
  const TripPlanError(this.message);
}

class TripPlanNotifier extends Notifier<TripPlanState> {
  @override
  TripPlanState build() => const TripPlanIdle();

  Future<void> generate(TripRequest request) async {
    state = const TripPlanLoading();
    try {
      final apiKey = ref.read(apiKeyProvider);
      if (apiKey.isEmpty) {
        state = const TripPlanError('Claude API 키를 마이페이지에서 먼저 입력해주세요.');
        return;
      }
      final repo = ref.read(tripRepositoryProvider);
      final plan = await repo.generatePlan(request, apiKey);
      state = TripPlanSuccess(plan);
    } catch (e, st) {
      // ignore: avoid_print
      print('🔴 여행 생성 오류: $e\n$st');
      state = TripPlanError(e.toString());
    }
  }

  void reset() => state = const TripPlanIdle();
}

final tripPlanProvider =
    NotifierProvider<TripPlanNotifier, TripPlanState>(TripPlanNotifier.new);

// ── 결과 화면의 현재 선택된 Day ────────────────────────

class SelectedDayNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void select(int day) => state = day;
  void reset() => state = 0;
}

final selectedDayProvider =
    NotifierProvider<SelectedDayNotifier, int>(SelectedDayNotifier.new);
