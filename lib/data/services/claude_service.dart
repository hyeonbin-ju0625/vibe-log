import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/place.dart';
import '../models/trip_plan.dart';
import '../models/trip_request.dart';

class ClaudeService {
  static const _model    = 'claude-haiku-4-5';
  static const _endpoint = 'https://api.anthropic.com/v1/messages';

  static const _times = ['09:00', '12:00', '15:00', '18:00'];

  static const _categoryEmoji = {
    PlaceCategory.food:          '🍽️',
    PlaceCategory.attraction:    '🏛️',
    PlaceCategory.culture:       '🎨',
    PlaceCategory.shopping:      '🛍️',
    PlaceCategory.experience:    '⭐',
    PlaceCategory.accommodation: '🏨',
  };

  // 시간대 인덱스 → 카테고리 순환
  static const _slotCategories = [
    PlaceCategory.food,
    PlaceCategory.attraction,
    PlaceCategory.culture,
    PlaceCategory.shopping,
  ];

  // (이름, lat, lng)
  static const _destPlaces = <String, List<(String, double, double)>>{
    '제주': [
      ('동문시장',        33.5140, 126.5294),
      ('용두암',          33.5161, 126.4975),
      ('성산일출봉',      33.4579, 126.9408),
      ('한라산',          33.3617, 126.5292),
      ('카페 더 클리프',  33.2397, 126.3106),
      ('흑돼지 거리',     33.4895, 126.4981),
      ('협재해수욕장',    33.3944, 126.2394),
      ('오설록 티뮤지엄', 33.3059, 126.2889),
    ],
    '도쿄': [
      ('아사쿠사 센소지',      35.7148, 139.7967),
      ('시부야 스크램블',      35.6595, 139.7005),
      ('하라주쿠 다케시타거리', 35.6702, 139.7027),
      ('도쿄타워',             35.6586, 139.7454),
      ('츠키지 시장',          35.6654, 139.7707),
      ('아키하바라',           35.7023, 139.7745),
      ('신주쿠 교엔',          35.6852, 139.7100),
      ('오모테산도',           35.6652, 139.7122),
    ],
    '부산': [
      ('해운대',      35.1588, 129.1603),
      ('광안리',      35.1531, 129.1186),
      ('감천문화마을', 35.0974, 129.0100),
      ('자갈치시장',  35.0970, 129.0301),
      ('태종대',      35.0497, 129.0850),
      ('범어사',      35.2864, 129.0584),
      ('서면 시장',   35.1575, 129.0592),
      ('용두산공원',  35.1011, 129.0329),
    ],
    '서울': [
      ('경복궁',      37.5796, 126.9770),
      ('명동',        37.5636, 126.9867),
      ('북촌한옥마을', 37.5826, 126.9830),
      ('홍대',        37.5577, 126.9249),
      ('남산타워',    37.5512, 126.9882),
      ('동대문 DDP',  37.5668, 127.0098),
      ('이태원',      37.5348, 126.9945),
      ('청계천',      37.5703, 126.9981),
    ],
  };

  // ── 공개 API ────────────────────────────────────────

  Future<TripPlan> generatePlan(TripRequest request, String apiKey,
      {int retry = 0}) async {
    try {
      return await _callClaude(request, apiKey, retry: retry);
    } catch (e) {
      // ignore: avoid_print
      print('⚠️ API 실패 - 더미 데이터로 폴백 ($e)');
      return _generateFallbackPlan(request);
    }
  }

  // ── Claude API 호출 ─────────────────────────────────

  Future<TripPlan> _callClaude(TripRequest request, String apiKey,
      {int retry = 0}) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
        'anthropic-dangerous-direct-browser-access': 'true',
      },
      body: jsonEncode({
        'model': _model,
        'max_tokens': 4096,
        'messages': [
          {'role': 'user', 'content': _buildPrompt(request)},
        ],
      }),
    );

    if (response.statusCode == 429 || response.statusCode == 503) {
      if (retry >= 2) {
        throw Exception('요청 한도 초과 (${response.statusCode})');
      }
      final waitSec = response.statusCode == 429 ? 35 : (retry + 1) * 2;
      // ignore: avoid_print
      print('⚠️ ${response.statusCode} 에러 - ${waitSec}초 후 재시도...');
      await Future.delayed(Duration(seconds: waitSec));
      return _callClaude(request, apiKey, retry: retry + 1);
    }

    if (response.statusCode != 200) {
      throw Exception('Claude API ${response.statusCode}: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final text =
        (data['content'] as List<dynamic>)[0]['text'] as String? ?? '';
    // ignore: avoid_print
    print('🟢 Claude textLen: ${text.length}');
    return _parsePlan(request, text);
  }

  // ── 폴백: 더미 데이터 생성 ──────────────────────────

  TripPlan _generateFallbackPlan(TripRequest request) {
    final dest   = request.destination;
    final days   = request.days;
    final rng    = Random();
    final pool   = _placePoolFor(dest);
    final places = <Place>[];

    for (int day = 1; day <= days; day++) {
      for (int slot = 0; slot < 4; slot++) {
        final idx      = ((day - 1) * 4 + slot) % pool.length;
        final category = _slotCategories[slot];
        final (name, lat, lng) = pool[idx];
        places.add(Place(
          day:         day,
          time:        _times[slot],
          name:        name,
          description: '$dest의 대표 명소입니다.',
          emoji:       _categoryEmoji[category]!,
          category:    category,
          mapX:        0.2 + rng.nextDouble() * 0.6,
          mapY:        0.2 + rng.nextDouble() * 0.6,
          lat:         lat,
          lng:         lng,
        ));
      }
    }

    return TripPlan(
      request:   request,
      places:    places,
      summary:   '$dest의 매력을 느낄 수 있는 ${days}박 ${days + 1}일 알찬 일정',
      createdAt: DateTime.now(),
    );
  }

  List<(String, double, double)> _placePoolFor(String dest) {
    for (final key in _destPlaces.keys) {
      if (dest.contains(key)) return _destPlaces[key]!;
    }
    // 그 외 목적지 — 좌표 없이 이름만 (지도 미표시)
    return [
      ('$dest 전통 시장',  0, 0),
      ('$dest 대표 관광지', 0, 0),
      ('$dest 문화 센터',  0, 0),
      ('$dest 쇼핑 거리',  0, 0),
      ('$dest 현지 맛집',  0, 0),
      ('$dest 역사 박물관', 0, 0),
      ('$dest 야경 명소',  0, 0),
      ('$dest 카페 거리',  0, 0),
    ];
  }

  // ── 프롬프트 & 파서 ─────────────────────────────────

  String _buildPrompt(TripRequest request) {
    final budget = (request.budget / 10000).round();
    return '''
여행 플래너야. 아래 여행의 장소 목록을 JSON으로만 답해.

목적지: ${request.destination}
기간: ${request.days}박 ${request.days + 1}일 (총 하루 4개씩 ${request.days * 4}개 장소)
예산: 약 $budget만원

JSON 형식 (다른 텍스트 없이 JSON만):
{"summary":"한줄요약","places":[{"day":1,"time":"09:00","name":"장소명","emoji":"🏛","category":"attraction","lat":33.0,"lng":126.0}]}

category: accommodation/food/attraction/experience/culture/shopping
lat/lng: 실제 위도경도 (소수점 4자리)
''';
  }

  TripPlan _parsePlan(TripRequest request, String text) {
    final cleaned = text
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();

    final summaryMatch =
        RegExp(r'"summary"\s*:\s*"((?:[^"\\]|\\.)*)"').firstMatch(cleaned);
    final summary =
        summaryMatch?.group(1) ?? '${request.destination} 여행 일정';

    try {
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(cleaned);
      if (jsonMatch != null) {
        final data =
            jsonDecode(jsonMatch.group(0)!) as Map<String, dynamic>;
        final placesJson = data['places'] as List<dynamic>? ?? [];
        final places = _parsePlaceList(placesJson);
        if (places.isNotEmpty) {
          return TripPlan(
              request:   request,
              places:    places,
              summary:   summary,
              createdAt: DateTime.now());
        }
      }
    } catch (_) {}

    final places = _extractCompletePlaces(cleaned);
    if (places.isEmpty) throw Exception('응답 파싱 실패: 장소 정보 없음');
    // ignore: avoid_print
    print('⚠️ 부분 파싱: ${places.length}개 장소 복구');
    return TripPlan(
        request:   request,
        places:    places,
        summary:   summary,
        createdAt: DateTime.now());
  }

  List<Place> _parsePlaceList(List<dynamic> placesJson) {
    return placesJson.map((p) {
      final map      = p as Map<String, dynamic>;
      final category = _parseCategory(map['category'] as String? ?? 'attraction');
      return Place(
        day:         (map['day'] as num).toInt(),
        time:        map['time'] as String? ?? '',
        name:        map['name'] as String? ?? '',
        emoji:       map['emoji'] as String? ?? '📍',
        description: _categoryLabel(category),
        category:    category,
        lat:         (map['lat'] as num?)?.toDouble(),
        lng:         (map['lng'] as num?)?.toDouble(),
      );
    }).toList();
  }

  List<Place> _extractCompletePlaces(String text) {
    final places   = <Place>[];
    int depth      = 0;
    int start      = -1;
    bool inString  = false;
    bool escape    = false;

    for (int i = 0; i < text.length; i++) {
      final ch = text[i];
      if (escape)        { escape = false; continue; }
      if (ch == '\\')    { escape = true;  continue; }
      if (ch == '"')     { inString = !inString; continue; }
      if (inString)      continue;

      if (ch == '{') {
        if (depth == 0) start = i;
        depth++;
      } else if (ch == '}') {
        depth--;
        if (depth == 0 && start != -1) {
          try {
            final objStr = text.substring(start, i + 1);
            final map    = jsonDecode(objStr) as Map<String, dynamic>;
            if (map.containsKey('day') && map.containsKey('name')) {
              final category =
                  _parseCategory(map['category'] as String? ?? 'attraction');
              places.add(Place(
                day:         (map['day'] as num).toInt(),
                time:        map['time'] as String? ?? '',
                name:        map['name'] as String? ?? '',
                emoji:       map['emoji'] as String? ?? '📍',
                description: _categoryLabel(category),
                category:    category,
                lat:         (map['lat'] as num?)?.toDouble(),
                lng:         (map['lng'] as num?)?.toDouble(),
              ));
            }
          } catch (_) {}
          start = -1;
        }
      }
    }
    return places;
  }

  String _categoryLabel(PlaceCategory category) => switch (category) {
    PlaceCategory.accommodation => '숙소',
    PlaceCategory.food          => '맛집',
    PlaceCategory.attraction    => '관광 명소',
    PlaceCategory.experience    => '체험',
    PlaceCategory.culture       => '문화',
    PlaceCategory.shopping      => '쇼핑',
  };

  PlaceCategory _parseCategory(String value) => switch (value) {
    'accommodation' => PlaceCategory.accommodation,
    'food'          => PlaceCategory.food,
    'attraction'    => PlaceCategory.attraction,
    'experience'    => PlaceCategory.experience,
    'culture'       => PlaceCategory.culture,
    'shopping'      => PlaceCategory.shopping,
    _               => PlaceCategory.attraction,
  };
}
