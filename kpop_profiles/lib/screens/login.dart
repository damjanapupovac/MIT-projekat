import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const routeName='/LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('K-Pop Profiles'),
      ),
      body: const Center(
        child: Text(
          'Login screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}