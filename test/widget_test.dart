import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_clase/views/coordinator_dashboard.dart';
import 'package:proyecto_clase/views/login_screen.dart';

void main() {
  testWidgets('Widget login autenticación fallida',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: LoginScreen(
      key: Key('LoginScreen'),
    )));

    expect(find.byKey(const Key('LoginScreen')), findsOneWidget);

    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginEmail')), 'a.com');

    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginPassword')), '123456');

    await tester.tap(find.byKey(const Key('ButtonLoginSubmit')));

    await tester.pumpAndSettle();

    expect(find.text('Invalid credentials! Please try again.'), findsOneWidget);
  });
  testWidgets('Widget login autenticación exitosa coordinador',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      title: 'Proyecto de Clase',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(
              key: Key('LoginScreen'),
            ),
        '/coordinator': (context) =>
            const CoordinatorDashboard(key: Key('CDashboard')),
      },
    ));

    expect(find.byKey(const Key('LoginScreen')), findsOneWidget);

    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginEmail')), 'a@a.com');

    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginPassword')), 'passwordA');

    await tester.tap(find.byKey(const Key('ButtonLoginSubmit')));

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('CDashboard')), findsOneWidget);
  });
}
