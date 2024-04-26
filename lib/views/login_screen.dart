import 'package:flutter/material.dart';
import '../controllers/coordinator_controller.dart';
import '../controllers/support_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final CoordinatorController coordinatorController = CoordinatorController();
  final SupportController supportController = SupportController();

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isWideScreen = size.width > 600;
    bool isWider = size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: isWideScreen ? size.width / 2 : size.width,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Flex(
                  direction: isWider ? Axis.horizontal : Axis.vertical,
                  children: <Widget>[
                    Expanded(
                        flex: isWider ? 1 : 0,
                        child: Image.asset("assets/logo.png",
                            height: isWider ? null : 120)),
                    Expanded(
                        flex: isWider ? 1 : 0,
                        child: Column(children: [
                          const SizedBox(height: 20),
                          TextFormField(
                            key: const Key('TextFormFieldLoginEmail'),
                            controller: emailController,
                            onFieldSubmitted: (string) => login(context),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            key: const Key('TextFormFieldLoginPassword'),
                            controller: passwordController,
                            obscureText: !_isPasswordVisible,
                            onFieldSubmitted: (string) => login(context),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(_isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            key: const Key('ButtonLoginSubmit'),
                            onPressed: () => login(context),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                            ),
                            child: const Text('Login'),
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/signup'),
                            child: Text('Sign Up for Support'),
                          )
                        ])),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void login(BuildContext context) async {
  bool coordinatorAuthenticated = await coordinatorController.validateCredentials(
    emailController.text, 
    passwordController.text
  );

  bool supportAuthenticated = await supportController.validateCredentials(
    emailController.text, 
    passwordController.text
  );

  if (coordinatorAuthenticated) {
    Navigator.pushNamed(context, '/coordinator');
  } else if (supportAuthenticated) {
    Navigator.pushNamed(context, '/support');
  } else {
    final snackBar = SnackBar(content: Text('Invalid credentials! Please try again.'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  }
}
