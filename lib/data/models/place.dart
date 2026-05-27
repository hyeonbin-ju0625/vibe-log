import 'package:flutter/material.dart';

enum PlaceCategory {
  accommodation,
  food,
  attraction,
  experience,
  culture,
  shopping,
}

extension PlaceCategoryX on PlaceCategory {
  String get label {
    switch (this) {
      case PlaceCategory.accommodation: return '숙소';
      case PlaceCategory.food:          return '식사';
      case PlaceCategory.attraction:    return '관광';
      case PlaceCategory.experience:    return '체험';
      case PlaceCategory.culture:       return '문화';
      case PlaceCategory.shopping:      return '쇼핑';
    }
  }

  Color get color {
    switch (this) {
      case PlaceCategory.accommodation: return const Color(0xFF7B6EF6);
      case PlaceCategory.food:          return const Color(0xFFFF6B9D);
      case PlaceCategory.attraction:    return const Color(0xFF00D4AA);
      case PlaceCategory.experience:    return const Color(0xFFFFBE0B);
      case PlaceCategory.culture:       return const Color(0xFFFF8E53);
      case PlaceCategory.shopping:      return const Color(0xFF0085FF);
    }
  }
}

/// 일정의 개별 장소 항목
class Place {
  final int day;
  final String time;       // "09:00" 형식
  final String name;
  final String description;
  final String emoji;
  final PlaceCategory category;

  // 지도용 위치 (0.0 ~ 1.0 비율)
  final double mapX;
  final double mapY;

  // 실제 좌표 (Google Maps 연동 후 사용)
  final double? lat;
  final double? lng;

  const Place({
    required this.day,
    required this.time,
    required this.name,
    required this.description,
    required this.emoji,
    required this.category,
    this.mapX = 0.5,
    this.mapY = 0.5,
    this.lat,
    this.lng,
  });

  Color get color => category.color;
}
