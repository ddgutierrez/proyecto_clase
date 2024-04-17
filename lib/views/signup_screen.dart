import 'package:flutter/material.dart';
import '../controllers/support_controller.dart';
import '../models/user_support.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final SupportController supportController = SupportController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signup for Support")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => createUser(),
                child: Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createUser() {
    if (nameController.text.isNotEmpty && emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      final newUser = UserSupport(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );
      supportController.addSupportUser(newUser);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please fill all fields"),
        backgroundColor: Colors.red,
      ));
    }
  }
}
