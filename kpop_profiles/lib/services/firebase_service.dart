import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> streamIdols() {
    return _db
        .collection('idols')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> updateFavorite(String docId, bool status) async {
    await _db.collection('idols').doc(docId).update({'isFavorite': status});
  }
}
