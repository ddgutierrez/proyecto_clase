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
      routes: {
        '/': (context) => const LoginScreen(
              key: Key('LoginScreen'),
            ),
        '/signup': (context) => const SignupScreen(key: Key('SignupScreen')),
        '/coordinator': (context) =>
            const CoordinatorDashboard(key: Key('CDashboard')),
        '/support': (context) => const SupportDashboard(key: Key('SDashboard')),
      },
    );
  }
}
