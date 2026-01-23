import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kpop_profiles/providers/auth_providers.dart';
import 'package:kpop_profiles/providers/theme_providers.dart';
import 'package:kpop_profiles/screens/add_group.dart';
import 'package:kpop_profiles/screens/edit_profile.dart';
import 'package:kpop_profiles/screens/login.dart';
import 'package:kpop_profiles/widgets/subtitle_text.dart';
import 'package:kpop_profiles/widgets/title_text.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const routeName = '/ProfileScreen';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkTheme = themeProvider.getIsDarkTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('K-Pop Profiles'),
        actions: [
          IconButton(
            onPressed: () {
              themeProvider.setDarkTheme(themeValue: !isDarkTheme);
            },
            icon: Icon(isDarkTheme ? Feather.sun : Feather.moon),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: auth.isLoggedIn
              ? _loggedInView(context, auth)
              : _loggedOutView(context),
        ),
      ),
    );
  }

  //GUEST
  Widget _loggedOutView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TitleText(label: "Profile"),
          const SizedBox(height: 12),
          const SubtitleText(label: "You are not logged in"),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(LoginScreen.routeName);
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }

  //USER
  Widget _loggedInView(BuildContext context, AuthProvider auth) {
    return Column(
      children: [
        const SizedBox(height: 24),
        CircleAvatar(
          radius: 48,
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: const Icon(Icons.person, size: 48),
        ),
        const SizedBox(height: 12),
        TitleText(label: auth.username),
        const SizedBox(height: 16),
        Divider(thickness: 1, color: Theme.of(context).dividerColor),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const SubtitleText(label: "Edit profile"),
          onTap: () {
            Navigator.of(context).pushNamed(EditProfileScreen.routeName);
          },
        ),
        //ADMIN
        if (auth.isAdmin)
          ListTile(
            leading: const Icon(Icons.add),
            title: const SubtitleText(label: "Add"),
            onTap: () {
              Navigator.of(context).pushNamed(AddGroupScreen.routeName);
            },
          ),
        const Spacer(),
        Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            onPressed: () {
              auth.logout();
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            },
          ),
        ),
      ],
    );
  }
}
