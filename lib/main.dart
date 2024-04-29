import 'package:flutter/material.dart';
import 'views/login_screen.dart';
import 'views/signup_screen.dart';
import 'views/coordinator_dashboard.dart';
import 'views/support_dashboard.dart';

void main() => runApp(const MyApp());

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
