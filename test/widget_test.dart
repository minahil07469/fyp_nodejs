import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(firebaseSupported: false));
    await tester.pump();
  });
}
