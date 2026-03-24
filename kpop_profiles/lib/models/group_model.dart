import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String id;
  final String name;
  final String imageUrl;

  GroupModel({required this.id, required this.name, required this.imageUrl});

  factory GroupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return GroupModel(
      id: doc.id,
      name: data?['name'] ?? '',
      imageUrl: data?['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'imageUrl': imageUrl};
  }
}
