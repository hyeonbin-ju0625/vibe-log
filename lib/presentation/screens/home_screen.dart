import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _destinationController = TextEditingController();
  int _days = 3;
  int _budget = 500000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TR — 여행 플래너'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('목적지', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _destinationController,
              decoration: const InputDecoration(
                hintText: '예: 도쿄, 파리, 제주도',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text('여행 기간', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Row(
              children: [
                IconButton(
                  onPressed: () => setState(() { if (_days > 1) _days--; }),
                  icon: const Icon(Icons.remove),
                ),
                Text('$_days 박 ${_days + 1} 일', style: const TextStyle(fontSize: 18)),
                IconButton(
                  onPressed: () => setState(() { _days++; }),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('예산', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Slider(
              value: _budget.toDouble(),
              min: 100000,
              max: 3000000,
              divisions: 29,
              label: '${(_budget / 10000).round()}만원',
              onChanged: (value) => setState(() { _budget = value.round(); }),
            ),
            Text('${(_budget / 10000).round()}만원', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/result',
                    arguments: {
                      'destination': _destinationController.text,
                      'days': _days,
                      'budget': _budget,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('일정 생성하기', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}