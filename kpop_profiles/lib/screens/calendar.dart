import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
DateTime selectedDate=DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('K-Pop Profiles'),
      ),
      body: const Center(
        child: Text(
          'Calendar screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}