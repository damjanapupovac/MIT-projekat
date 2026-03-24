import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kpop_profiles/models/idol_model.dart';

class IdolProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<IdolModel> _idols = [];
  List<String> _userFavoriteIds = [];

  List<IdolModel> get idols => _idols;
  List<IdolModel> get favouriteIdols =>
      _idols.where((idol) => _userFavoriteIds.contains(idol.id)).toList();

  IdolProvider() {
    _initAuthListener();
    fetchIdols();
  }

  void _initAuthListener() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _db.collection('user_favorites').doc(user.uid).snapshots().listen((
          doc,
        ) {
          _userFavoriteIds = (doc.exists && doc.data() != null)
              ? List<String>.from(doc.data()!['favorites'] ?? [])
              : [];
          _updateLocalFavorites();
        });
      } else {
        _userFavoriteIds = [];
        _updateLocalFavorites();
      }
    });
  }

  void _updateLocalFavorites() {
    for (var idol in _idols) {
      idol.isFavorite = _userFavoriteIds.contains(idol.id);
    }
    notifyListeners();
  }

  void fetchIdols() {
    _db.collection('idols').snapshots().listen((snapshot) {
      _idols = snapshot.docs.map((doc) {
        final idol = IdolModel.fromFirestore(doc);
        idol.isFavorite = _userFavoriteIds.contains(idol.id);
        return idol;
      }).toList();
      notifyListeners();
    });
  }

  Future<void> toggleFavourite(String idolId) async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      final isFav = _userFavoriteIds.contains(idolId);
      final userFavRef = _db.collection('user_favorites').doc(user.uid);

      if (isFav) {
        await userFavRef.update({
          'favorites': FieldValue.arrayRemove([idolId]),
        });
      } else {
        await userFavRef.set({
          'favorites': FieldValue.arrayUnion([idolId]),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint("Error toggling favorite: $e");
    }
  }

  Future<void> addIdol(IdolModel idol) async {
    try {
      await _db.collection('idols').doc(idol.id).set(idol.toMap());
    } catch (e) {
      debugPrint("Error adding idol: $e");
    }
  }

  Future<void> addIdolComment(String idolId, String text) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final commentDoc = _db.collection('comments').doc();
      await commentDoc.set({
        'id': commentDoc.id,
        'targetId': idolId,
        'userId': user.uid,
        'username': user.displayName ?? "Fan",
        'userImage': user.photoURL ?? "",
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
        'likedBy': [],
      });
    } catch (e) {
      debugPrint("Error adding comment: $e");
    }
  }

  Future<void> deleteIdolComment(String commentId) async {
    try {
      await _db.collection('comments').doc(commentId).delete();
    } catch (e) {
      debugPrint("Error deleting comment: $e");
    }
  }

  Future<void> toggleIdolCommentLike(
    String commentId,
    List<String> likedBy,
  ) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final commentRef = _db.collection('comments').doc(commentId);
      if (likedBy.contains(user.uid)) {
        await commentRef.update({
          'likedBy': FieldValue.arrayRemove([user.uid]),
        });
      } else {
        await commentRef.update({
          'likedBy': FieldValue.arrayUnion([user.uid]),
        });
      }
    } catch (e) {
      debugPrint("Error liking comment: $e");
    }
  }
}
