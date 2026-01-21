import 'package:flutter/material.dart';
import 'package:kpop_profiles/providers/theme_providers.dart';
import 'package:provider/provider.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkTheme = themeProvider.getIsDarkTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('K-Pop Profiles'),
        actions: [
          IconButton(onPressed: (){
            themeProvider.setDarkTheme(themeValue: !isDarkTheme);
          },
            icon: Icon(
              isDarkTheme ? Feather.sun : Feather.moon,
            ),
          )
        ],
      ),
      body: const Center(
        child: Text(
          'Profile screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}