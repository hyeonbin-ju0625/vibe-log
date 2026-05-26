import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  final List<Map<String, dynamic>> dummyLocations = const [
    {'name': '호텔', 'address': '시내 중심가', 'day': 'Day 1', 'lat': 35.6762, 'lng': 139.6503},
    {'name': '현지 맛집', 'address': '번화가 골목', 'day': 'Day 1', 'lat': 35.6812, 'lng': 139.6553},
    {'name': '주요 관광지', 'address': '관광 명소', 'day': 'Day 1', 'lat': 35.6892, 'lng': 139.6923},
    {'name': '로컬 시장', 'address': '전통 시장', 'day': 'Day 2', 'lat': 35.7012, 'lng': 139.7753},
    {'name': '박물관', 'address': '문화 구역', 'day': 'Day 2', 'lat': 35.7162, 'lng': 139.7603},
    {'name': '야경 명소', 'address': '전망대', 'day': 'Day 2', 'lat': 35.6582, 'lng': 139.7453},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('지도로 보기'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 지도 영역 (더미)
          Container(
            height: 300,
            color: Colors.grey.shade200,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 80, color: Colors.blue),
                  SizedBox(height: 12),
                  Text('Google Maps 연동 예정', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text('API 키 설정 후 실제 지도 표시', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ),
          // 장소 목록
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dummyLocations.length,
              itemBuilder: (context, index) {
                final loc = dummyLocations[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: loc['day'] == 'Day 1' ? Colors.blue : Colors.green,
                      child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(loc['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${loc['day']} · ${loc['address']}'),
                    trailing: const Icon(Icons.location_on, color: Colors.red),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}