import 'package:flutter/material.dart';
import 'package:kpop_profiles/consts/themes.dart';
import 'package:kpop_profiles/providers/auth_providers.dart';
import 'package:kpop_profiles/providers/comment_provider.dart';
import 'package:kpop_profiles/providers/favourite_provider.dart';
import 'package:kpop_profiles/providers/group_provider.dart';
import 'package:kpop_profiles/providers/idol_provider.dart';
import 'package:kpop_profiles/providers/theme_providers.dart';
import 'package:kpop_profiles/screens/add_group.dart';
import 'package:kpop_profiles/screens/edit_profile.dart';
import 'package:kpop_profiles/screens/favourites.dart';
import 'package:kpop_profiles/screens/login.dart';
import 'package:kpop_profiles/screens/profile_screen.dart';
import 'package:kpop_profiles/screens/register.dart';
import 'package:kpop_profiles/screens/root_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyARNJw6vc1zhRMG_g2iFpLUyqD0FNdKJe8',
      appId: '1:590889112063:web:caa3dc736b77e4862157ca',
      messagingSenderId: '590889112063',
      projectId: 'mitprojekat-a05cc',
      storageBucket: 'mitprojekat-a05cc.firebasestorage.app',
      authDomain: "mitprojekat-a05cc.firebaseapp.com",
      measurementId: "G-D06MLVM8JJ",
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => IdolProvider()),
        ChangeNotifierProvider(create: (_) => GroupProvider()),
        ChangeNotifierProvider(create: (_) => FavouriteProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider())
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
          home: const AuthWrapper(),

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

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    if (authProvider.isLoggedIn) {
      return const RootScreen();
    } else {
      return const LoginScreen();
    }
  }
}
