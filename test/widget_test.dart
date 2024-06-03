import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:proyecto_clase/data/datasources/remote/i_user_datasource.dart';
import 'package:proyecto_clase/data/datasources/remote/user_datasource.dart';
import 'package:proyecto_clase/data/repositories/user_repository.dart';
import 'package:proyecto_clase/domain/repositories/i_user_repository.dart';
import 'package:proyecto_clase/domain/use_case/user_usecase.dart';
import 'package:proyecto_clase/ui/controllers/support_controller.dart';
import 'package:proyecto_clase/ui/views/coordinator_dashboard.dart';
import 'package:proyecto_clase/ui/views/login_screen.dart';

void main() {
  setUp(() {
    Get.put<IUserDataSource>(UserDataSource());
    Get.put<IUserRepository>(UserRepository(Get.find()));
    Get.put(UserUseCase(Get.find()));
    Get.put(SupportController());
  });

  testWidgets('Widget login autenticación fallida',
      (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(
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
    await tester.pumpWidget(GetMaterialApp(
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
