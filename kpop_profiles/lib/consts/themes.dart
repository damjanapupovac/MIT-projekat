import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'app_colours.dart';

class Styles {
  static ThemeData themeData({required bool isDarkTheme}) {
    return ThemeData(
      useMaterial3: true,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,

      scaffoldBackgroundColor: isDarkTheme
          ? AppColours.darkScaffoldColour
          : AppColours.lightScaffoldColour,

      colorScheme: ColorScheme(
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        primary: isDarkTheme ? AppColours.darkPrimary : AppColours.lightPrimary, 
        onPrimary: Colors.white,
        secondary: isDarkTheme ? AppColours.darkPrimary: AppColours.lightPrimary,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        surface: isDarkTheme ? AppColours.darkCardColour : AppColours.lightCardColour,
        onSurface: isDarkTheme ? AppColours.darkTextPrimary : AppColours.lightTextPrimary,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: isDarkTheme
            ? AppColours.darkScaffoldColour 
            : AppColours.lightScaffoldColour,
        foregroundColor: isDarkTheme
            ? AppColours.darkTextPrimary
            : AppColours.lightTextPrimary,
        elevation: 0,
        centerTitle: true,
      ),

      cardTheme: CardThemeData(
        elevation: 2,
        surfaceTintColor: Colors.transparent, 
        color: isDarkTheme
            ? AppColours.darkCardColour
            : AppColours.lightCardColour,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDarkTheme
            ? AppColours.darkCardColour
            : AppColours.lightCardColour,
        indicatorColor: isDarkTheme ? AppColours.darkPrimary.withValues(alpha: 0.2) : AppColours.lightPrimary.withValues(alpha: 0.2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: isDarkTheme ? AppColours.darkPrimary : AppColours.lightPrimary);
          }
          return IconThemeData(
            color: isDarkTheme ? AppColours.darkTextSecondary : AppColours.lightTextSecondary,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.bold : FontWeight.w500,
            color: states.contains(WidgetState.selected) 
                ? (isDarkTheme ?  AppColours.darkPrimary :  AppColours.lightPrimary )
                : (isDarkTheme ? AppColours.darkTextSecondary : AppColours.lightTextSecondary),
          );
        }),
      ),

      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: isDarkTheme ? AppColours.darkTextPrimary : AppColours.lightTextPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: isDarkTheme ? AppColours.darkTextSecondary : AppColours.lightTextSecondary,
          fontSize: 14,
        ),
      ),
    );
  }
  static CalendarStyle calendarStyle(BuildContext context) {
  return CalendarStyle(
    selectedDecoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
      shape: BoxShape.circle,
    ),
    todayDecoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
      shape: BoxShape.circle,
    ),
    defaultTextStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
    weekendTextStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
  );
}
}
