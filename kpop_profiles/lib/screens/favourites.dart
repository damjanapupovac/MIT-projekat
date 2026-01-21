import 'package:flutter/material.dart';

class Favourites extends StatefulWidget {
  static const routeName='/Favourites';
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('K-Pop Profiles'),
      ),
      body: const Center(
        child: Text(
          'Favourites screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}