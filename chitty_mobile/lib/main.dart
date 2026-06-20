import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const ChittyApp());
}

class ChittyApp extends StatelessWidget {
  const ChittyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chitty Finance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}