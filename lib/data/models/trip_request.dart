/// 사용자가 홈 화면에서 입력하는 여행 요청 정보
class TripRequest {
  final String destination;
  final int days;
  final int budget; // 원 단위

  const TripRequest({
    required this.destination,
    required this.days,
    required this.budget,
  });

  TripRequest copyWith({
    String? destination,
    int? days,
    int? budget,
  }) {
    return TripRequest(
      destination: destination ?? this.destination,
      days: days ?? this.days,
      budget: budget ?? this.budget,
    );
  }

  @override
  String toString() =>
      'TripRequest(destination: $destination, days: $days, budget: $budget)';
}
