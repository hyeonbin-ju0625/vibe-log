import 'package:flutter_test/flutter_test.dart';
import 'package:tr/main.dart';

void main() {
  testWidgets('TR 앱 smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TRApp());
    expect(find.text('TR'), findsAny);
  });
}
