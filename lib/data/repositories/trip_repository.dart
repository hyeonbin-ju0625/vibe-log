import '../models/place.dart';
import '../models/trip_plan.dart';
import '../models/trip_request.dart';

/// 여행 일정 생성 리포지토리
/// 현재: 목적지별 더미 데이터
/// 추후: Claude API 호출로 교체
class TripRepository {
  static const _instance = TripRepository._();
  const TripRepository._();
  factory TripRepository() => _instance;

  /// 요청에 맞는 여행 일정 생성 (현재는 더미)
  Future<TripPlan> generatePlan(TripRequest request) async {
    // AI 생성 흉내 — 약간의 딜레이
    await Future.delayed(const Duration(milliseconds: 1200));

    final places = _buildPlaces(request);

    return TripPlan(
      request: request,
      places: places,
      summary: _summary(request),
      createdAt: DateTime.now(),
    );
  }

  // ── 목적지별 일정 ─────────────────────────────────────

  List<Place> _buildPlaces(TripRequest req) {
    final dest = req.destination;
    final days = req.days;

    // 알려진 도시면 특화 데이터, 아니면 기본 템플릿
    final builder = _destinationMap[dest] ?? _generic;
    return builder(req).take(days * 4).toList(); // 하루 최대 4개
  }

  String _summary(TripRequest req) {
    final dest = req.destination;
    final known = _destinationMap.containsKey(dest);
    if (known) {
      return '${dest}의 핵심만 담은 ${req.days}박 ${req.days + 1}일 코스';
    }
    return '${dest} ${req.days}박 ${req.days + 1}일 • 예산 ${(req.budget / 10000).round()}만원';
  }

  // ── 도쿄 ──────────────────────────────────────────────

  static List<Place> _tokyo(TripRequest req) => [
    const Place(day: 1, time: '11:00', name: '시부야 스크램블 교차로', emoji: '🚦',
        description: '세계에서 가장 바쁜 교차로. 새벽 2시에도 사람이 넘친다.',
        category: PlaceCategory.attraction, mapX: 0.22, mapY: 0.34),
    const Place(day: 1, time: '13:00', name: '이치란 라멘', emoji: '🍜',
        description: '1인 칸막이 좌석에서 몰입감 있게 즐기는 일본식 돈코츠 라멘.',
        category: PlaceCategory.food, mapX: 0.45, mapY: 0.20),
    const Place(day: 1, time: '15:30', name: '하라주쿠 다케시타 거리', emoji: '🛍️',
        description: '크레이프, 팝컬처, 독특한 패션으로 가득한 골목.',
        category: PlaceCategory.shopping, mapX: 0.68, mapY: 0.42),
    const Place(day: 1, time: '19:30', name: '신주쿠 골든가이', emoji: '🏮',
        description: '2~3평짜리 바 200개. 현지인들의 진짜 술자리 문화.',
        category: PlaceCategory.experience, mapX: 0.82, mapY: 0.25),
    const Place(day: 2, time: '09:00', name: '아사쿠사 센소지', emoji: '⛩️',
        description: '도쿄에서 가장 오래된 절. 이른 아침 인파 없을 때가 절정.',
        category: PlaceCategory.culture, mapX: 0.30, mapY: 0.60),
    const Place(day: 2, time: '12:00', name: '스시 다이 (츠키지)', emoji: '🍣',
        description: '새벽 어시장 옆 줄 서서 먹는 진짜 스시 오마카세.',
        category: PlaceCategory.food, mapX: 0.55, mapY: 0.75),
    const Place(day: 2, time: '15:00', name: '아키하바라', emoji: '🎮',
        description: '게임·애니·전자기기의 성지. 멀티 타워 빌딩이 즐비.',
        category: PlaceCategory.shopping, mapX: 0.72, mapY: 0.60),
    const Place(day: 2, time: '20:00', name: '도쿄 스카이트리 전망대', emoji: '🗼',
        description: '634m 높이에서 도쿄 야경 전경. 맑은 날엔 후지산도 보인다.',
        category: PlaceCategory.attraction, mapX: 0.88, mapY: 0.72),
    const Place(day: 3, time: '10:00', name: '우에노 공원 & 박물관', emoji: '🎨',
        description: '국립박물관, 동물원, 벚꽃 명소가 한 곳에 집결.',
        category: PlaceCategory.culture, mapX: 0.18, mapY: 0.52),
    const Place(day: 3, time: '14:00', name: '오다이바 팀랩 보더리스', emoji: '💡',
        description: '경계 없는 디지털 아트 공간. 시간 가는 줄 모른다.',
        category: PlaceCategory.experience, mapX: 0.40, mapY: 0.80),
  ];

  // ── 파리 ──────────────────────────────────────────────

  static List<Place> _paris(TripRequest req) => [
    const Place(day: 1, time: '10:00', name: '에펠탑', emoji: '🗼',
        description: '오전에 방문해 관광객이 몰리기 전 전망대를 즐겨요.',
        category: PlaceCategory.attraction, mapX: 0.25, mapY: 0.30),
    const Place(day: 1, time: '13:00', name: '카페 드 플로르', emoji: '☕',
        description: '사르트르와 보부아르가 단골이었던 생제르맹 카페. 크루아상이 일품.',
        category: PlaceCategory.food, mapX: 0.48, mapY: 0.22),
    const Place(day: 1, time: '15:00', name: '루브르 박물관', emoji: '🏛️',
        description: '모나리자, 밀로의 비너스. 하루를 다 써도 모자라.',
        category: PlaceCategory.culture, mapX: 0.70, mapY: 0.44),
    const Place(day: 1, time: '19:30', name: '몽마르트르 야경', emoji: '🌆',
        description: '사크레쾨르 대성당 앞 계단에서 내려다보는 파리 야경.',
        category: PlaceCategory.attraction, mapX: 0.85, mapY: 0.28),
    const Place(day: 2, time: '09:30', name: '오르세 미술관', emoji: '🎨',
        description: '인상파의 집합소. 모네, 르누아르, 반 고흐 진품이 즐비.',
        category: PlaceCategory.culture, mapX: 0.32, mapY: 0.58),
    const Place(day: 2, time: '12:30', name: '르 마레 팔라펠 골목', emoji: '🥙',
        description: '파리 최고의 팔라펠 샌드위치를 서서 먹는 유대인 거리.',
        category: PlaceCategory.food, mapX: 0.58, mapY: 0.70),
    const Place(day: 2, time: '15:00', name: '베르사유 궁전', emoji: '👑',
        description: '태양왕 루이 14세의 거대한 바로크 궁전과 정원.',
        category: PlaceCategory.culture, mapX: 0.75, mapY: 0.62),
    const Place(day: 2, time: '20:00', name: '센 강 유람선 디너', emoji: '🚢',
        description: '파리의 야경을 강 위에서. 다리마다 조명이 켜진다.',
        category: PlaceCategory.experience, mapX: 0.90, mapY: 0.78),
  ];

  // ── 발리 ──────────────────────────────────────────────

  static List<Place> _bali(TripRequest req) => [
    const Place(day: 1, time: '07:00', name: '우붓 라이스 테라스', emoji: '🌾',
        description: '이른 아침 안개 낀 계단식 논. 발리의 상징적 풍경.',
        category: PlaceCategory.attraction, mapX: 0.20, mapY: 0.28),
    const Place(day: 1, time: '11:00', name: '사원 탐방 (따나롯)', emoji: '🕌',
        description: '바다 위 바위 위에 세워진 힌두 사원. 일몰이 압권.',
        category: PlaceCategory.culture, mapX: 0.45, mapY: 0.18),
    const Place(day: 1, time: '14:00', name: '루왁 커피 농장', emoji: '☕',
        description: '세계에서 가장 비싼 커피를 농장에서 직접 시음.',
        category: PlaceCategory.experience, mapX: 0.68, mapY: 0.40),
    const Place(day: 1, time: '18:30', name: '꾸따 비치 선셋', emoji: '🌅',
        description: '발리에서 가장 유명한 선셋 포인트. 서퍼들의 실루엣이 장관.',
        category: PlaceCategory.attraction, mapX: 0.82, mapY: 0.25),
    const Place(day: 2, time: '08:00', name: '우붓 전통 시장', emoji: '🛒',
        description: '현지 과일, 수공예품, 향신료가 넘치는 재래시장.',
        category: PlaceCategory.shopping, mapX: 0.28, mapY: 0.60),
    const Place(day: 2, time: '12:00', name: '와룽 레스토랑 점심', emoji: '🍛',
        description: '나시고렝, 미고렝을 현지 식당에서. 500원짜리 코코넛 음료.',
        category: PlaceCategory.food, mapX: 0.55, mapY: 0.72),
    const Place(day: 2, time: '15:00', name: '원숭이 숲 (몽키 포레스트)', emoji: '🐒',
        description: '200여 마리 원숭이가 자유롭게 돌아다니는 신성한 숲.',
        category: PlaceCategory.attraction, mapX: 0.72, mapY: 0.58),
    const Place(day: 2, time: '19:00', name: '케착 댄스 공연', emoji: '🎭',
        description: '100명이 합창하는 힌두 전통 불춤. 일몰 시간에 맞춰 시작.',
        category: PlaceCategory.experience, mapX: 0.88, mapY: 0.70),
  ];

  // ── 제주 ──────────────────────────────────────────────

  static List<Place> _jeju(TripRequest req) => [
    const Place(day: 1, time: '10:00', name: '성산일출봉', emoji: '🌋',
        description: '거대한 분화구와 탁 트인 바다. 이른 아침 일출이 명물.',
        category: PlaceCategory.attraction, mapX: 0.22, mapY: 0.30),
    const Place(day: 1, time: '13:00', name: '흑돼지 거리', emoji: '🥩',
        description: '제주 흑돼지 구이. 두꺼운 두께로 구워 겉바속촉.',
        category: PlaceCategory.food, mapX: 0.48, mapY: 0.20),
    const Place(day: 1, time: '15:30', name: '만장굴', emoji: '🕳️',
        description: '세계 최장 용암 동굴. 내부 온도 11도로 여름에도 시원.',
        category: PlaceCategory.attraction, mapX: 0.72, mapY: 0.42),
    const Place(day: 1, time: '18:00', name: '협재 해수욕장 선셋', emoji: '🌊',
        description: '에메랄드빛 바다와 하얀 백사장. 비양도가 배경.',
        category: PlaceCategory.attraction, mapX: 0.85, mapY: 0.28),
    const Place(day: 2, time: '09:00', name: '한라산 등반', emoji: '⛰️',
        description: '어리목 코스로 윗세오름까지. 왕복 4시간의 트레킹.',
        category: PlaceCategory.experience, mapX: 0.30, mapY: 0.62),
    const Place(day: 2, time: '13:00', name: '올레시장 해물라면', emoji: '🍜',
        description: '등반 후 먹는 해물라면은 꿀맛. 귤 한 봉지도 챙기기.',
        category: PlaceCategory.food, mapX: 0.58, mapY: 0.72),
    const Place(day: 2, time: '15:30', name: '카멜리아 힐', emoji: '🌺',
        description: '동백꽃 600여 품종. 인스타 성지로 유명한 정원.',
        category: PlaceCategory.experience, mapX: 0.75, mapY: 0.60),
    const Place(day: 2, time: '18:30', name: '우도 자전거 투어', emoji: '🚲',
        description: '제주 앞바다 작은 섬. 자전거로 한 바퀴 돌면 1시간.',
        category: PlaceCategory.experience, mapX: 0.90, mapY: 0.80),
  ];

  // ── 기본 템플릿 (알 수 없는 도시) ────────────────────

  static List<Place> _generic(TripRequest req) {
    final dest = req.destination;
    return [
      Place(day: 1, time: '10:00', name: '$dest 도착 & 호텔 체크인', emoji: '🏨',
          description: '짐을 풀고 숙소 근처 카페에서 여행의 시작을 즐기세요.',
          category: PlaceCategory.accommodation, mapX: 0.18, mapY: 0.30),
      Place(day: 1, time: '13:00', name: '현지 인기 맛집 점심', emoji: '🍽️',
          description: '구글 평점 4.5 이상의 현지인이 찾는 식당.',
          category: PlaceCategory.food, mapX: 0.45, mapY: 0.20),
      Place(day: 1, time: '15:30', name: '$dest 랜드마크 탐방', emoji: '🏛️',
          description: '도시를 대표하는 명소를 여유롭게 돌아보세요.',
          category: PlaceCategory.attraction, mapX: 0.72, mapY: 0.44),
      Place(day: 1, time: '19:30', name: '루프탑 바 디너', emoji: '🌃',
          description: '야경을 감상하며 분위기 있는 저녁 식사.',
          category: PlaceCategory.food, mapX: 0.85, mapY: 0.28),
      Place(day: 2, time: '09:00', name: '로컬 시장 투어', emoji: '🛒',
          description: '이른 아침 현지 재래시장. 현지인처럼 아침을 시작해요.',
          category: PlaceCategory.experience, mapX: 0.28, mapY: 0.60),
      Place(day: 2, time: '12:30', name: '문화 지구 탐방', emoji: '🎨',
          description: '박물관과 갤러리로 이어진 문화 구역.',
          category: PlaceCategory.culture, mapX: 0.55, mapY: 0.72),
      Place(day: 2, time: '16:00', name: '쇼핑 & 로컬 기념품', emoji: '🛍️',
          description: '현지 브랜드와 독특한 기념품을 건질 수 있는 골목.',
          category: PlaceCategory.shopping, mapX: 0.72, mapY: 0.60),
      Place(day: 2, time: '20:00', name: '야경 전망대', emoji: '🌆',
          description: '도시 전체가 한눈에 보이는 전망대에서 마무리.',
          category: PlaceCategory.attraction, mapX: 0.88, mapY: 0.78),
      Place(day: 3, time: '10:00', name: '근교 자연 탐방', emoji: '🌿',
          description: '도시 근교의 자연 명소. 트레킹이나 드라이브 코스.',
          category: PlaceCategory.experience, mapX: 0.20, mapY: 0.52),
      Place(day: 3, time: '14:00', name: '로컬 체험 클래스', emoji: '🎭',
          description: '요리, 공예, 공연 등 현지 문화를 직접 체험.',
          category: PlaceCategory.experience, mapX: 0.45, mapY: 0.80),
    ];
  }

  static final Map<String, List<Place> Function(TripRequest)> _destinationMap = {
    '도쿄': _tokyo,
    '파리': _paris,
    '발리': _bali,
    '제주': _jeju,
  };
}
