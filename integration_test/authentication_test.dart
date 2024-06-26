import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:proyecto_clase/data/core/network_info.dart';
import 'package:proyecto_clase/data/datasources/local/i_report_local_datasource.dart';
import 'package:proyecto_clase/data/datasources/local/report_local_datasource.dart';
import 'package:proyecto_clase/data/datasources/remote/client_datasource.dart';
import 'package:proyecto_clase/data/datasources/remote/coordinator_datasource.dart';
import 'package:proyecto_clase/data/datasources/remote/i_client_datasource.dart';
import 'package:proyecto_clase/data/datasources/remote/i_coordinator_datasource.dart';
import 'package:proyecto_clase/data/datasources/remote/i_report_datasource.dart';
import 'package:proyecto_clase/data/datasources/remote/i_user_datasource.dart';
import 'package:proyecto_clase/data/datasources/remote/report_datasource.dart';
import 'package:proyecto_clase/data/datasources/remote/user_datasource.dart';
import 'package:proyecto_clase/data/models/report_db.dart';
import 'package:proyecto_clase/data/repositories/client_repository.dart';
import 'package:proyecto_clase/data/repositories/coordinator_repository.dart';
import 'package:proyecto_clase/data/repositories/report_repository.dart';
import 'package:proyecto_clase/data/repositories/user_repository.dart';
import 'package:proyecto_clase/domain/repositories/i_client_repository.dart';
import 'package:proyecto_clase/domain/repositories/i_coordinator_repository.dart';
import 'package:proyecto_clase/domain/repositories/i_report_repository.dart';
import 'package:proyecto_clase/domain/repositories/i_user_repository.dart';
import 'package:proyecto_clase/domain/use_case/client_usecase.dart';
import 'package:proyecto_clase/domain/use_case/coordinator_usecase.dart';
import 'package:proyecto_clase/domain/use_case/report_usecase.dart';
import 'package:proyecto_clase/domain/use_case/user_usecase.dart';
import 'package:proyecto_clase/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:proyecto_clase/ui/controllers/client_controller.dart';
import 'package:proyecto_clase/ui/controllers/connectivity_controller.dart';
import 'package:proyecto_clase/ui/controllers/coordinator_controller.dart';
import 'package:proyecto_clase/ui/controllers/report_controller.dart';
import 'package:proyecto_clase/ui/controllers/support_controller.dart';
import 'package:proyecto_clase/ui/views/support_dashboard.dart';

Future<void> _initHive() async {
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(ReportDbAdapter());
  }
  await Hive.initFlutter();
}

Future<void> _openBox() async {
  await _initHive();
  await Hive.openBox('reportsDb');
  await Hive.openBox('reportsDbOffline');
}

Future<Widget> createHomeScreen() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _openBox();
  Get.put<IClientDataSource>(ClientDataSource());
  Get.put<IClientRepository>(ClientRepository(Get.find()));
  Get.put(ClientUseCase(Get.find()));
  Get.put(ClientController());

  Get.put<IUserDataSource>(UserDataSource());
  Get.put<IUserRepository>(UserRepository(Get.find()));
  Get.put(UserUseCase(Get.find()));
  Get.put(SupportController());

  Get.put(NetworkInfo());
  Get.put<IReportDataSource>(ReportDataSource());
  Get.put<IReportLocalDataSource>(ReportLocalDatasource());
  Get.put<IReportRepository>(
      ReportRepository(Get.find(), Get.find(), Get.find()));
  Get.put(ReportUseCase(Get.find()));
  Get.put(ConnectivityController());
  Get.put(ReportController());

  Get.put<ICoordinatorDataSource>(CoordinatorDatasource());
  Get.put<ICoordinatorRepository>(CoordinatorRepository(Get.find()));
  Get.put(CoordinatorUseCase(Get.find()));
  Get.put(CoordinatorController());
  return const MyApp();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Login -> login exitoso -> logout", (WidgetTester tester) async {
    Widget w = await createHomeScreen();
    await tester.pumpWidget(w);
    expect(find.byKey(const Key('LoginScreen')), findsOneWidget);
    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginEmail')), 'a@a.com');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginPassword')), 'passwordA');
    await tester.ensureVisible(find.byKey(const Key('ButtonLoginSubmit')));
    await tester.tap(find.byKey(const Key('ButtonLoginSubmit')));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.byKey(const Key('CDashboard')), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('ButtonLogOut')));
    await tester.tap(find.byKey(const Key('ButtonLogOut')));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.byKey(const Key('LoginScreen')), findsOneWidget);
  });

  testWidgets("Login -> login failed", (WidgetTester tester) async {
    Widget w = await createHomeScreen();
    await tester.pumpWidget(w);
    expect(find.byKey(const Key('LoginScreen')), findsOneWidget);
    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginEmail')), 'a.com');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginPassword')), 'wrongpassword');
    await tester.ensureVisible(find.byKey(const Key('ButtonLoginSubmit')));
    await tester.tap(find.byKey(const Key('ButtonLoginSubmit')));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.byKey(const Key('LoginScreen')), findsOneWidget);
  });

  testWidgets("Login -> Support Dashboard -> logout", (WidgetTester tester) async {
    Widget w = await createHomeScreen();
    await tester.pumpWidget(w);
    expect(find.byKey(const Key('LoginScreen')), findsOneWidget);
    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginEmail')), 'test@test.com');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginPassword')), 'password');
    await tester.ensureVisible(find.byKey(const Key('ButtonLoginSubmit')));
    await tester.tap(find.byKey(const Key('ButtonLoginSubmit')));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.byType(SupportDashboard), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await tester.ensureVisible(find.byKey(const Key('ButtonLogOut')));
    await tester.tap(find.byKey(const Key('ButtonLogOut')));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.byKey(const Key('LoginScreen')), findsOneWidget);
  });
}
