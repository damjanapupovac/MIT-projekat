import 'package:flutter/material.dart';
import 'package:kpop_profiles/screens/calendar.dart';
import 'package:kpop_profiles/screens/favourites.dart';
import 'package:kpop_profiles/screens/home_screen.dart';
import 'package:kpop_profiles/screens/profile_screen.dart';
import 'package:kpop_profiles/screens/search_screen.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class RootScreen extends StatefulWidget {
  static const routeName='/RootScreen';
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
late List<Widget> screens;
int currentScreen=0;
late PageController controller;

@override
  void initState() {
    super.initState();
    screens=const[
      HomeScreen(),
      SearchScreen(),
      Calendar(),
      Favourites(),
      ProfileScreen()
    ];
    controller=PageController(initialPage: currentScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(physics: const NeverScrollableScrollPhysics(), controller: controller, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentScreen,
        height: kBottomNavigationBarHeight,
        onDestinationSelected: (index){
          setState(() {
            currentScreen=index;
          });
          controller.jumpToPage(currentScreen);
        },
        destinations: [
          NavigationDestination(icon: Icon(IconlyBold.home), label: "Home"),
          NavigationDestination(icon: Icon(IconlyBold.search), label: "Search"),
          NavigationDestination(icon: Icon(IconlyBold.calendar), label: "Calendar"),
          NavigationDestination(icon: Icon(IconlyBold.heart), label: "Favourites"),
          NavigationDestination(icon: Icon(IconlyBold.profile), label: "Prosile")
        ],
      ),
    );
  }
}