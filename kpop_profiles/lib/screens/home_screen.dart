import 'package:flutter/material.dart';
import 'package:kpop_profiles/providers/auth_providers.dart';
import 'package:kpop_profiles/screens/favourites.dart';
import 'package:provider/provider.dart';
import '../services/news_service.dart';
import '../providers/idol_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final idolProvider = Provider.of<IdolProvider>(context);
    final favoriteIdols = idolProvider.idols.where((i) => i.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('K-Pop Home'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                "Latest K-Pop News",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 250,
              child: FutureBuilder<List<dynamic>>(
                future: NewsService().fetchKpopNews(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Could not load news."));
                  } else {
                    final news = snapshot.data!.take(7).toList();
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: news.length,
                      itemBuilder: (context, index) {
                        final article = news[index];
                        return Container(
                          width: 280,
                          margin: const EdgeInsets.only(right: 15, bottom: 10),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(15)),
                                  child: Image.network(
                                    article['urlToImage'] ?? '',
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(
                                        height: 120, color: Colors.grey[300]),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    article['title'] ?? 'No Title',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const Divider(height: 40, thickness: 1, indent: 16, endIndent: 16),
            if (authProvider.isLoggedIn) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Your Favorites",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(Favourites.routeName),
                      child: const Text("Show More"),
                    ),
                  ],
                ),
              ),
              if (favoriteIdols.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Favorite list is empty."),
                )
              else
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: favoriteIdols.length,
                    itemBuilder: (context, index) {
                      final idol = favoriteIdols[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.pinkAccent,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            const SizedBox(height: 5),
                            Text(idol.name,
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}