import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kpop_profiles/providers/idol_provider.dart';
import 'package:kpop_profiles/screens/idol_profile.dart';
import '../models/enums.dart';

class Favourites extends StatelessWidget {
  static const routeName = "/FavouritesScreen";
  const Favourites({super.key});

  @override
  Widget build(BuildContext context) {
    final idolProvider = Provider.of<IdolProvider>(context);
    final favouriteIdols = idolProvider.favouriteIdols;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Favourite Idols"),
        centerTitle: true,
      ),
      body: favouriteIdols.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 10),
                  const Text(
                    "No favourite idols yet!",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: favouriteIdols.length,
              itemBuilder: (ctx, i) {
                final idol = favouriteIdols[i];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IdolProfileScreen(
                            idol: idol,
                            role: UserRole.user,
                          ),
                        ),
                      );
                    },
                    contentPadding: const EdgeInsets.all(10),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: idol.imageUrl != null && idol.imageUrl!.isNotEmpty
                          ? NetworkImage(idol.imageUrl!)
                          : null,
                      child: idol.imageUrl == null || idol.imageUrl!.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(
                      idol.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text("Birthday: ${idol.birthday}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red, size: 28),
                      onPressed: () {
                        idolProvider.toggleFavourite(idol.id);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}