import 'package:flutter/material.dart';
import '../controllers/coordinator_controller.dart';
import '../controllers/support_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final CoordinatorController coordinatorController = CoordinatorController();
  final SupportController supportController = SupportController();

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => login(context),
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: Text('Sign Up for Support'),
                  style: TextButton.styleFrom(
                    primary: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login(BuildContext context) {
    if (coordinatorController.validateCredentials(emailController.text, passwordController.text)) {
      Navigator.pushNamed(context, '/coordinator');
    } else if (supportController.validateCredentials(emailController.text, passwordController.text)) {
      Navigator.pushNamed(context, '/support');
    } else {
      final snackBar = SnackBar(content: Text('Invalid credentials! Please try again.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
