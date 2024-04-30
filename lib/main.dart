import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ui/views/login_screen.dart';
import 'ui/views/signup_screen.dart';
import 'ui/views/coordinator_dashboard.dart';
import 'ui/views/support_dashboard.dart';
import 'ui/controllers/client_controller.dart';
import 'data/datasources/remote/client_datasource.dart';
import 'data/repositories/client_repository.dart';
import 'domain/use_case/client_usecase.dart';
import 'package:proyecto_clase/data/datasources/remote/i_client_datasource.dart';
import 'package:proyecto_clase/domain/repositories/i_client_repository.dart';
import 'ui/controllers/support_controller.dart';
import 'data/datasources/remote/user_datasource.dart';
import 'data/repositories/user_repository.dart';
import 'domain/use_case/user_usecase.dart';
import 'package:proyecto_clase/data/datasources/remote/i_user_datasource.dart';
import 'package:proyecto_clase/domain/repositories/i_user_repository.dart';
void main() {
  Get.put<IClientDataSource>(ClientDataSource());
  Get.put<IClientRepository>(ClientRepository(Get.find()));
  Get.put(ClientUseCase(Get.find()));
  Get.put(ClientController());
  Get.put<IUserDataSource>(UserDataSource());
  Get.put<IUserRepository>(UserRepository(Get.find()));
  Get.put(UserUseCase(Get.find()));
  Get.put(SupportController());

  runApp(const MyApp());
  }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/background.jpg'), context);

    return MaterialApp(
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
        return MaterialPageRoute(builder: (context) => const CoordinatorDashboard());
      case '/support':
        // Extract the arguments and pass them to the SupportDashboard
        final args = settings.arguments as Map<String, dynamic>?;
        String id = args?['supportUserId'] ?? '0';  // Default to '0' or handle appropriately
        return MaterialPageRoute(
          builder: (context) => SupportDashboard(id: id),
        );
      default:
        // Undefined route
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
