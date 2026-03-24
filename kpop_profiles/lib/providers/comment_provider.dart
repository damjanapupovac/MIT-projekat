import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kpop_profiles/models/comment_model.dart';

class CommentProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<CommentModel>> getComments(String targetId) {
    return _db.collection('comments').snapshots().map((snapshot) {
      List<CommentModel> allComments = snapshot.docs.map((doc) {
        return CommentModel.fromMap(doc.data());
      }).toList();

      List<CommentModel> filtered = allComments
          .where((c) => c.targetId == targetId)
          .toList();

      return filtered;
    });
  }

  Future<void> addComment(
    String targetId,
    String text,
    String currentUsername,
    String currentUserImage,
  ) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _db.collection('comments').doc();

    final newComment = CommentModel(
      id: docRef.id,
      userId: user.uid,
      username: currentUsername,
      userImage: currentUserImage,
      text: text,
      targetId: targetId,
      likedBy: [],
    );

    final data = newComment.toMap();
    data['createdAt'] = FieldValue.serverTimestamp();

    try {
      await docRef.set(data);
    } catch (e) {
      debugPrint("Greška pri dodavanju komentara: $e");
    }
  }

  Future<void> toggleLike(String commentId, List<String> likedBy) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _db.collection('comments').doc(commentId);

    try {
      if (likedBy.contains(user.uid)) {
        await docRef.update({
          'likedBy': FieldValue.arrayRemove([user.uid]),
        });
      } else {
        await docRef.update({
          'likedBy': FieldValue.arrayUnion([user.uid]),
        });
      }
    } catch (e) {
      debugPrint("Greška pri lajkovanju: $e");
    }
  }

  Future<void> deleteComment(String commentId) async {
    try {
      await _db.collection('comments').doc(commentId).delete();
    } catch (e) {
      debugPrint("Greška pri brisanju: $e");
    }
  }
}
