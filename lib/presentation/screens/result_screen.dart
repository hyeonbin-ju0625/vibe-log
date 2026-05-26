import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  // 더미 데이터
  final List<Map<String, String>> dummyPlan = const [
    {'day': 'Day 1', 'time': '09:00', 'place': '도착 및 호텔 체크인', 'desc': '짐 풀고 근처 카페에서 휴식'},
    {'day': 'Day 1', 'time': '12:00', 'place': '현지 맛집 점심', 'desc': '구글 평점 4.5 이상 식당'},
    {'day': 'Day 1', 'time': '14:00', 'place': '주요 관광지 방문', 'desc': '대표 명소 탐방'},
    {'day': 'Day 2', 'time': '09:00', 'place': '로컬 시장 구경', 'desc': '현지 분위기 체험'},
    {'day': 'Day 2', 'time': '13:00', 'place': '박물관/미술관', 'desc': '문화 탐방'},
    {'day': 'Day 2', 'time': '18:00', 'place': '야경 명소', 'desc': '저녁 식사 후 야경 감상'},
  ];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final destination = args['destination'] ?? '목적지';
    final days = args['days'] ?? 3;
    final budget = args['budget'] ?? 500000;

    return Scaffold(
      appBar: AppBar(
        title: Text('$destination 여행 일정'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/map'),
            icon: const Icon(Icons.map),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _infoChip('목적지', destination),
                _infoChip('기간', '$days박 ${days + 1}일'),
                _infoChip('예산', '${(budget / 10000).round()}만원'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dummyPlan.length,
              itemBuilder: (context, index) {
                final item = dummyPlan[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(item['day']!.split(' ')[1], style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                    title: Text(item['place']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${item['time']} · ${item['desc']}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}