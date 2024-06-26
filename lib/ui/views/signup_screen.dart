import 'package:flutter/material.dart';
import '../controllers/support_controller.dart';
import '../../domain/models/user_support.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final SupportController supportController = SupportController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: const Text("Signup for Support")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              TextField(
                key: const Key('TextFieldSignUpName'),
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                key: const Key('TextFieldSignUpEmail'),
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                key: const Key('TextFieldSignUpPassword'),
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                key: const Key('ButtonSignUpSubmit'),
                onPressed: () => createUser(),
                child: const Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createUser() async {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      final newUser = UserSupport(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );
      try {
        await supportController.addUser(newUser);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill all fields"),
        backgroundColor: Colors.red,
      ));
    }
  }
}
