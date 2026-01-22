import 'package:flutter/material.dart';
import 'package:kpop_profiles/screens/login.dart';
import 'package:kpop_profiles/widgets/title_text.dart';
import 'package:kpop_profiles/widgets/subtitle_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  
  static const routeName='/ProfileScreen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool isLoggedIn = false;
  String username = "@user";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isLoggedIn ? _loggedInView() : _loggedOutView(),
        ),
      ),
    );
  }

  ///GUEST
  Widget _loggedOutView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TitleText(label: "Profile"),
          const SizedBox(height: 12),
          const SubtitleText(
            label: "You are not logged in",
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                Navigator.of(context).pushNamed(LoginScreen.routeName);
              });
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }

  /// KORISNIK
  Widget _loggedInView() {
    return Column(
      children: [
        const SizedBox(height: 24),
        CircleAvatar(
          radius: 48,
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: const Icon(
            Icons.person,
            size: 48,
          ),
        ),
        const SizedBox(height: 12),
        TitleText(label: username),
        const SizedBox(height: 16),
        Divider(
          thickness: 1,
          color: Theme.of(context).dividerColor,
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const SubtitleText(label: "Edit profile"),
          onTap: () {
            // TODO: navigacija na EditProfileScreen
          },
        ),
        const Spacer(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const SubtitleText(label: "Logout"),
          onTap: () {
            setState(() {
              isLoggedIn = false;
            });
          },
        ),
      ],
    );
  }
}
