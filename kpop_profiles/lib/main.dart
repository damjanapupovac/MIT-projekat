import 'package:flutter/material.dart';
import 'package:kpop_profiles/screens/favourites.dart';
import 'package:kpop_profiles/screens/login.dart';
import 'package:kpop_profiles/screens/root_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'K-Pop Profiles',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const RootScreen(),
      routes: {
        RootScreen.routeName:(context)=>const RootScreen(),
        Favourites.routeName:(context)=>const Favourites(),
        //RegisterScreen.routName:(context)=>const RegisterScreen(),
        LoginScreen.routeName:(context)=>const LoginScreen(),
      }
    );
  }
}
