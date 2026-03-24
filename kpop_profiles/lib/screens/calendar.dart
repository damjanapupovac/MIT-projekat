import 'package:flutter/material.dart';
import 'package:kpop_profiles/providers/auth_providers.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/idol_provider.dart';
import '../consts/themes.dart';
import '../models/idol_model.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  bool _isBirthday(IdolModel idol, DateTime day) {
    if (idol.birthday.isEmpty) return false;
    try {
      String cleanBirthday = idol.birthday.trim();
      List<String> parts = cleanBirthday.contains('.')
          ? cleanBirthday.split('.')
          : cleanBirthday.split('-');

      if (parts.length < 2) return false;

      int bDay = int.parse(parts[0].trim());
      int bMonth = int.parse(parts[1].trim());

      return bDay == day.day && bMonth == day.month;
    } catch (e) {
      return false;
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final idolProvider = Provider.of<IdolProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('K-Pop Birthday Calendar'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2050, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: Styles.calendarStyle(context),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            eventLoader: (day) {
              return idolProvider.idols.where((idol) {
                return idol.isFavorite && _isBirthday(idol, day);
              }).toList();
            },
          ),
          const Divider(thickness: 1),
          Expanded(child: _buildBirthdaySection(authProvider, idolProvider)),
        ],
      ),
    );
  }

  Widget _buildBirthdaySection(AuthProvider auth, IdolProvider idolProvider) {
    if (!auth.isLoggedIn) {
      return const Center(child: Text("Please login to see birthday events"));
    }

    if (_selectedDay == null) {
      return const Center(child: Text("Select a day to see birthdays"));
    }

    final birthdayIdols = idolProvider.idols
        .where((idol) => idol.isFavorite && _isBirthday(idol, _selectedDay!))
        .toList();

    if (birthdayIdols.isNotEmpty) {
      return ListView.builder(
        itemCount: birthdayIdols.length,
        itemBuilder: (context, index) {
          final idol = birthdayIdols[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage:
                      (idol.imageUrl != null && idol.imageUrl!.isNotEmpty)
                      ? NetworkImage(idol.imageUrl!)
                      : null,
                  child: (idol.imageUrl == null || idol.imageUrl!.isEmpty)
                      ? const Icon(Icons.cake, color: Colors.white)
                      : null,
                ),
                title: Text(
                  "${idol.name}'s Birthday!",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Don't forget to celebrate! 🎉"),
              ),
            ),
          );
        },
      );
    }
    return const Center(child: Text("No favourite idol birthdays on this day"));
  }
}
