import 'package:flutter/material.dart';
import 'package:testing_flutter/home.dart';

void main() {
  runApp(
    MaterialApp(
      home: const Home(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[850],
      ),
    ),
  );
}
