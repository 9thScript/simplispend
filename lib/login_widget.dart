import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    String username = usernameController.text; // Assume username is the email
    String password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog('Both username and password must be filled');
      return;
    }

    // If fields are filled, proceed with login
    _loginUser(username, password);
  }

  Future<void> _loginUser(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacementNamed(context, 'Home');
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message ?? 'Login failed');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Adjust layout for keyboard
        backgroundColor: const Color(0xFF1F242D),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // Placeholder for logo
                Padding(
                  padding: const EdgeInsets.only(bottom: 100, top: 50),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/img/Logo.png',
                      width: 314,
                      height: 83,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Username field
                _buildLabel('Email Address'),
                _buildTextField(usernameController, 'Email Address'),
                const SizedBox(height: 30),
                // Password field
                _buildLabel('Password'),
                _buildTextField(passwordController, 'Password',
                    obscureText: true),
                const SizedBox(height: 50),
                // Login button
                ElevatedButton(
                  onPressed:
                      _validateForm, // Validate form when button is pressed
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFCC74),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 120, vertical: 12),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  child: const Text('Log in',
                      style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(height: 25),
                // Sign Up option
                const Text(
                  "Don't have an account?",
                  style: TextStyle(color: Color(0xFFD9D9D9)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, 'Register'); // Navigate to RegisterWidget
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color(0xFFF3C370),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, bottom: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(color: Color(0xFFD9D9D9), fontSize: 17),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
