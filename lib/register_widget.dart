import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Firebase registration method
  Future<void> _registerUser(
      String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update the display name for the user
      await userCredential.user?.updateDisplayName(username);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Registration successful!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, 'Login');
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message ?? 'Registration failed');
    }
  }

  // Validation function
  void _validateForm() {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Check if any field is empty
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showErrorDialog('All fields must be filled');
      return;
    }

    // Check if password length is at least 8 characters
    if (password.length < 8) {
      _showErrorDialog('Password must be at least 8 characters long');
      return;
    }

    // Check if password and confirm password match
    if (password != confirmPassword) {
      _showErrorDialog('Passwords do not match');
      return;
    }

    // If everything is valid, proceed with registration
    _registerUser(email, password, username); // Call Firebase registration
  }

  // Function to show error dialog
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
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFF1F242D),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),
                // Welcome message
                const Text(
                  'Welcome to SimpliSpend!',
                  style: TextStyle(
                    color: Color(0xFFF3C370),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Input fields
                buildTextField('Username', _usernameController),
                buildTextField('Email', _emailController),
                buildTextField('Password', _passwordController,
                    obscureText: true),
                buildTextField('Confirm Password', _confirmPasswordController,
                    obscureText: true),
                const SizedBox(height: 30),
                // Register button
                ElevatedButton(
                  onPressed: _validateForm, // Validate form and register
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
                  child: const Text('Register',
                      style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(height: 20),
                // Sign In option
                const Text(
                  'Already have an account?',
                  style: TextStyle(
                    color: Color(0xFFD9D9D9),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'Login');
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Color(0xFFF3C370),
                      fontSize: 16,
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

  Widget buildTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(24),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(24),
          ),
          filled: true,
          fillColor: const Color.fromRGBO(21, 20, 43, 1),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
