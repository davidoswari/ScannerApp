import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart'; // Replace with your main app screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scanner App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(
        onLogin: (username) {
          // Navigate to MainScreen after login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        },
      ),
    );
  }
}
