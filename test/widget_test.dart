import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow_app/providers/settings_provider.dart';
import 'package:taskflow_app/main.dart';

void main() {
  testWidgets('App starts without error', (WidgetTester tester) async {
    final settings = SettingsProvider();
    await tester.pumpWidget(TaskFlowApp(settings: settings));
    expect(find.text('TaskFlow.'), findsOneWidget);
  });
}
