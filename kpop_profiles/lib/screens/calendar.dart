import 'package:flutter/material.dart';
import 'package:kpop_profiles/providers/auth_providers.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/idol_provider.dart';
import '../consts/themes.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final idolProvider = Provider.of<IdolProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Column(
        children: [
          TableCalendar(
            calendarFormat: CalendarFormat.month,
            headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
            calendarStyle: Styles.calendarStyle(context),
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2050, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
          ),
          Divider(thickness: 1, color: Theme.of(context).dividerColor),
          Expanded(
            child: _buildBirthdaySection(authProvider, idolProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildBirthdaySection(AuthProvider auth, IdolProvider idolProvider) {
    if (!auth.isLoggedIn) {
      return const Center(child: Text("You need to login to see events"));
    }

    final nayeon = idolProvider.idols.firstWhere((element) => element.id == '101');

    if (_selectedDay != null && 
        _selectedDay!.month == 9 && 
        _selectedDay!.day == 22) {
      
      if (nayeon.isFavorite) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Card(
            elevation: 0,
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Theme.of(context).primaryColor),
            ),
            child: ListTile(
              leading: Icon(Icons.cake, color: Theme.of(context).primaryColor),
              title: Text("${nayeon.name}'s Birthday!", style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Don't forget to celebrate! 🎉"),
            ),
          ),
        );
      }
    }
    return const Center(child: Text("No events for this day"));
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }
}