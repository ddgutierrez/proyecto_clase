import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:loggy/loggy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:proyecto_clase/data/core/network_info.dart';
import 'package:proyecto_clase/data/datasources/local/i_report_local_datasource.dart';
import 'package:proyecto_clase/data/datasources/local/report_local_datasource.dart';
//datasources/remote
import 'package:proyecto_clase/data/datasources/remote/i_report_datasource.dart';
import 'package:proyecto_clase/data/datasources/remote/i_client_datasource.dart';
import 'package:proyecto_clase/data/datasources/remote/i_user_datasource.dart';
import 'package:proyecto_clase/data/datasources/remote/report_datasource.dart';
import 'package:proyecto_clase/data/datasources/remote/client_datasource.dart';
import 'package:proyecto_clase/data/datasources/remote/user_datasource.dart';
import 'package:proyecto_clase/data/models/report_db.dart';
import 'package:proyecto_clase/ui/controllers/connectivity_controller.dart';

//domain/use_case
import 'domain/use_case/report_usecase.dart';
import 'domain/use_case/client_usecase.dart';
import 'domain/use_case/user_usecase.dart';

//controllers
import 'package:proyecto_clase/ui/controllers/report_controller.dart';
import 'package:proyecto_clase/ui/controllers/support_controller.dart';
import 'package:proyecto_clase/ui/controllers/client_controller.dart';

//views
import 'ui/views/login_screen.dart';
import 'ui/views/signup_screen.dart';
import 'ui/views/coordinator_dashboard.dart';
import 'ui/views/support_dashboard.dart';

//repositories
import 'data/repositories/client_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/report_repository.dart';

//i_repository
import 'package:proyecto_clase/domain/repositories/i_client_repository.dart';
import 'package:proyecto_clase/domain/repositories/i_user_repository.dart';
import 'package:proyecto_clase/domain/repositories/i_report_repository.dart';

Future<List<Box>> _openBox() async {
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  List<Box> boxList = [];
  await Hive.initFlutter();
  Hive.registerAdapter(ReportDbAdapter());
  boxList.add(await Hive.openBox('reportsDb'));
  boxList.add(await Hive.openBox('reportsDbOffline'));
  logInfo("Box opened reportsDb ${await Hive.boxExists('reportsDb')}");
  logInfo(
      "Box opened reportsDbOffline ${await Hive.boxExists('reportsDbOffline')}");
  return boxList;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Loggy.initLoggy(logPrinter: const PrettyPrinter(showColors: true));
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/background.jpg'), context);

    return GetMaterialApp(
      title: 'Proyecto de Clase',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic>? _getRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (context) => const SignupScreen());
      case '/coordinator':
        return MaterialPageRoute(
            builder: (context) => const CoordinatorDashboard());
      case '/support':
        final args = settings.arguments as Map<String, dynamic>?;
        String id = args?['supportUserId'] ?? '0';
        return MaterialPageRoute(
          builder: (context) => SupportDashboard(id: id),
        );
      default:
        return _errorRoute();
    }
  }

  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Page not found!'),
        ),
      );
    });
  }
}
