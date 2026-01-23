import 'package:flutter/material.dart';
import 'package:kpop_profiles/providers/auth_providers.dart';
import 'package:kpop_profiles/providers/idol_provider.dart';
import 'package:kpop_profiles/screens/idol_profile.dart';
import 'package:provider/provider.dart';
import '../models/enums.dart';

class Favourites extends StatefulWidget {
  static const routeName = '/Favourites';
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final idolProvider = Provider.of<IdolProvider>(context);

    if (!authProvider.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('Favourites')),
        body: const Center(
          child: Text(
            'You need to login to see your favourites',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    final favoriteIdols = idolProvider.favoriteIdols;
    final currentRole = authProvider.isAdmin ? UserRole.admin : UserRole.user;

    return Scaffold(
      appBar: AppBar(title: const Text('My Favourites')),
      body: favoriteIdols.isEmpty
          ? const Center(child: Text("No favorites yet!"))
          : ListView.builder(
              itemCount: favoriteIdols.length,
              itemBuilder: (context, index) {
                final idol = favoriteIdols[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  child: ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) =>
                            IdolProfileScreen(idol: idol, role: currentRole),
                      ),
                    ),
                    leading: const CircleAvatar(
                      child: Icon(Icons.star, color: Colors.orange),
                    ),
                    title: Text(
                      idol.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(idol.birthday),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () => idolProvider.toggleFavorite(idol.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
