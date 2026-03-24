import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kpop_profiles/models/idol_model.dart';
import 'package:kpop_profiles/models/group_model.dart';

class GroupProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<GroupModel> _groups = [];
  List<GroupModel> get groups => _groups;

  GroupProvider() {
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    print("DEBUG: Pokrećem slušanje kolekcije 'groups'...");
    _db
        .collection('groups')
        .snapshots()
        .listen(
          (snapshot) {
            print(
              "DEBUG: Primljeno ${snapshot.docs.length} dokumenata iz baze.",
            );
            _groups = snapshot.docs
                .map((doc) => GroupModel.fromFirestore(doc))
                .toList();
            notifyListeners();
          },
          onError: (error) {
            print("DEBUG GREŠKA kod čitanja: $error");
          },
        );
  }

  Future<String> _uploadImage(File imageFile, String fileName) async {
    try {
      Reference ref = _storage
          .ref()
          .child('group_images')
          .child('$fileName.jpg');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("DEBUG GREŠKA kod uploada slike: $e");
      return "";
    }
  }

  Future<String?> addGroup({
    required String name,
    File? imageFile,
    required List<IdolModel> idols,
  }) async {
    try {
      DocumentReference groupRef = _db.collection('groups').doc();
      String imageUrl = "";
      if (imageFile != null) {
        imageUrl = await _uploadImage(imageFile, groupRef.id);
      }

      await groupRef.set({
        'id': groupRef.id,
        'name': name,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      WriteBatch batch = _db.batch();
      for (var idol in idols) {
        DocumentReference idolRef = _db.collection('idols').doc();
        batch.set(idolRef, {
          'id': idolRef.id,
          'name': idol.name,
          'birthday': idol.birthday,
          'imageUrl': idol.imageUrl ?? '',
          'groupId': groupRef.id,
          'isFavorite': false,
        });
      }
      await batch.commit();

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateGroup({
    required String groupId,
    required String name,
    File? imageFile,
    String? oldImageUrl,
    required List<IdolModel> idols,
  }) async {
    try {
      print("DEBUG: Ažuriram grupu ID: $groupId");
      String imageUrl = oldImageUrl ?? "";

      if (imageFile != null) {
        imageUrl = await _uploadImage(imageFile, groupId);
      }

      for (var idol in idols) {
        idol.groupId = groupId;
      }

      await _db.collection('groups').doc(groupId).update({
        'name': name,
        'imageUrl': imageUrl,
        'idols': idols.map((idol) => idol.toMap()).toList(),
      });

      print("DEBUG: Grupa uspešno ažurirana.");
      return null;
    } catch (e) {
      print("DEBUG GREŠKA kod ažuriranja: $e");
      return e.toString();
    }
  }

  Future<String?> deleteGroup(String groupId) async {
    try {
      print("DEBUG: Brišem grupu ID: $groupId");
      await _db.collection('groups').doc(groupId).delete();
      print("DEBUG: Grupa obrisana.");
      return null;
    } catch (e) {
      print("DEBUG GREŠKA kod brisanja: $e");
      return e.toString();
    }
  }
}
