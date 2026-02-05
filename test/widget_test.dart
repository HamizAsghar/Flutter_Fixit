import 'package:flutter_test/flutter_test.dart';
import 'package:fixit/main.dart';

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const FixitApp());
    expect(find.byType(FixitApp), findsOneWidget);
  });
}
