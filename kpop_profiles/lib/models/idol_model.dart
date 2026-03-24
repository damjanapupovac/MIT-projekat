import 'package:cloud_firestore/cloud_firestore.dart';

class IdolModel {
  final String id;
  String name;
  String birthday;
  String? imageUrl;
  String groupId;
  bool isFavorite;

  IdolModel({
    required this.id,
    required this.name,
    required this.birthday,
    this.imageUrl,
    required this.groupId,
    this.isFavorite = false,
  });

  factory IdolModel.fromMap(Map<String, dynamic> map, String docId) {
    return IdolModel(
      id: docId.isNotEmpty ? docId : (map['id'] ?? ''),
      name: map['name'] ?? '',
      birthday: map['birthday'] ?? '',
      imageUrl: map['imageUrl'],
      groupId: map['groupId'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  factory IdolModel.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return IdolModel.fromMap(map, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birthday': birthday,
      'imageUrl': imageUrl,
      'groupId': groupId,
      'isFavorite': isFavorite,
    };
  }
}
