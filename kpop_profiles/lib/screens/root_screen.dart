import 'package:flutter/material.dart';
import 'package:kpop_profiles/models/enums.dart';
import 'package:kpop_profiles/models/idol_model.dart';
import 'package:kpop_profiles/providers/auth_providers.dart';
import 'package:provider/provider.dart';
import 'package:kpop_profiles/models/group_model.dart';
import 'package:kpop_profiles/screens/calendar.dart';
import 'package:kpop_profiles/screens/favourites.dart';
import 'package:kpop_profiles/screens/home_screen.dart';
import 'package:kpop_profiles/screens/profile_screen.dart';
import 'package:kpop_profiles/screens/search_screen.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});
  
  static const routeName = '/RootScreen';

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int currentScreen = 0;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: currentScreen);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    UserRole currentRole = UserRole.guest;
    if (authProvider.isLoggedIn) {
      currentRole = authProvider.isAdmin ? UserRole.admin : UserRole.user;
    }

    final List<Widget> screens = [
      const HomeScreen(),
      SearchScreen(role: currentRole),
      const Calendar(),
      const Favourites(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentScreen,
        height: kBottomNavigationBarHeight,
        onDestinationSelected: (index) {
          setState(() {
            currentScreen = index;
          });
          controller.jumpToPage(currentScreen);
        },
        destinations: const [
          NavigationDestination(icon: Icon(IconlyBold.home), label: "Home"),
          NavigationDestination(icon: Icon(IconlyBold.search), label: "Search"),
          NavigationDestination(icon: Icon(IconlyBold.calendar), label: "Calendar"),
          NavigationDestination(icon: Icon(IconlyBold.heart), label: "Favourites"),
          NavigationDestination(icon: Icon(IconlyBold.profile), label: "Profile"),
        ],
      ),
    );
  }
}