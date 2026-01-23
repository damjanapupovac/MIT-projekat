import 'package:flutter/material.dart';
import 'package:kpop_profiles/consts/themes.dart';
import 'package:kpop_profiles/providers/auth_providers.dart';
import 'package:kpop_profiles/providers/theme_providers.dart';
import 'package:kpop_profiles/screens/add_group.dart';
import 'package:kpop_profiles/screens/edit_profile.dart';
import 'package:kpop_profiles/screens/favourites.dart';
import 'package:kpop_profiles/screens/login.dart';
import 'package:kpop_profiles/screens/profile_screen.dart';
import 'package:kpop_profiles/screens/register.dart';
import 'package:kpop_profiles/screens/root_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'K-Pop Profiles',
          theme: Styles.themeData(isDarkTheme: themeProvider.getIsDarkTheme),
          home: const RootScreen(),

          routes: {
            RootScreen.routeName: (context) => const RootScreen(),
            Favourites.routeName: (context) => const Favourites(),
            LoginScreen.routeName: (context) => const LoginScreen(),
            RegisterScreen.routeName: (context) => const RegisterScreen(),
            ProfileScreen.routeName: (context) => const ProfileScreen(),
            EditProfileScreen.routeName: (context) => const EditProfileScreen(),
            AddGroupScreen.routeName: (context) => AddGroupScreen(),
          },
        );
      },
    );
  }
}
