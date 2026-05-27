import 'trip_request.dart';
import 'place.dart';

/// AI가 생성한 (또는 더미) 여행 일정 전체
class TripPlan {
  final TripRequest request;
  final List<Place> places;
  final String summary;       // 한 줄 요약
  final DateTime createdAt;

  const TripPlan({
    required this.request,
    required this.places,
    required this.summary,
    required this.createdAt,
  });

  /// 특정 day의 장소만 필터
  List<Place> placesForDay(int day) =>
      day == 0 ? places : places.where((p) => p.day == day).toList();

  /// 총 day 수
  int get totalDays =>
      places.isEmpty ? 0 : places.map((p) => p.day).reduce((a, b) => a > b ? a : b);
}
