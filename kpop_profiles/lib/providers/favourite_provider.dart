import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavouriteProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> _favouriteIds = [];

  List<String> get favouriteIds => _favouriteIds;

  FavouriteProvider() {
    fetchFavourites();
  }

  Future<void> fetchFavourites() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final doc = await _db
          .collection('users')
          .doc(user.uid)
          .collection('favouriteGroups')
          .get();
      _favouriteIds = doc.docs.map((d) => d.id).toList();
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> toggleFavourite(String groupId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _db
        .collection('users')
        .doc(user.uid)
        .collection('favouriteGroups')
        .doc(groupId);

    if (_favouriteIds.contains(groupId)) {
      _favouriteIds.remove(groupId);
      await docRef.delete();
    } else {
      _favouriteIds.add(groupId);
      await docRef.set({
        'addedAt': Timestamp.now(),
      });
    }
    notifyListeners();
  }

  bool isFavourite(String groupId) {
    return _favouriteIds.contains(groupId);
  }
}