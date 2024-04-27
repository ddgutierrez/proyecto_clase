import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_clase/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// IMPORTANT NOTE
/// For reasons beyond me running the integration test on windows requires that
/// the pumpAndSettle method is used with a duration longer than the default,
/// otherwise the test fails. Use the pumpAndSettle method with extended duration
/// after pressing buttons and a new screen is expected
void main() {
  Future<Widget> createHomeScreen() async {
    WidgetsFlutterBinding.ensureInitialized();
    return const MyApp();
  }

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets("Login -> login exitoso -> logout", (WidgetTester tester) async {
    Widget w = await createHomeScreen();
    await tester.pumpWidget(w);
    expect(find.byKey(const Key('LoginScreen')), findsOneWidget);
    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginEmail')), 'a@a.com');

    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginPassword')), 'passwordA');

    await tester.tap(find.byKey(const Key('ButtonLoginSubmit')));

    await tester.pumpAndSettle(Durations.extralong4);

    expect(find.byKey(const Key('CDashboard')), findsOneWidget);

    await tester.tap(find.byKey(const Key('ButtonLogOut')));

    await tester.pumpAndSettle(Durations.extralong4);

    expect(find.byKey(const Key('LoginScreen')), findsOneWidget);
  });
}
