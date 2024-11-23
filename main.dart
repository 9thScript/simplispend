import 'package:flutter/material.dart';
import 'login_widget.dart';
import 'register_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF1F242D),
      ),
      initialRoute: 'Login',
      routes: {
        'Login': (context) => const LoginWidget(),
        'Register': (context) => const RegisterWidget(),
      },
    );
  }
}
