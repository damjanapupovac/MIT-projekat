import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('K-Pop Profiles'),
      ),
      body: const Center(
        child: Text(
          'Home screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}