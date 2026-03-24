import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String userId;
  final String username;
  final String userImage;
  final String text;
  final String targetId;
  final DateTime? createdAt;
  List<String> likedBy;

  CommentModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.userImage,
    required this.text,
    required this.targetId,
    this.createdAt,
    List<String>? likedBy,
  }) : this.likedBy = likedBy ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userImage': userImage,
      'text': text,
      'targetId': targetId,
      'likedBy': likedBy,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      username: map['username']?.toString() ?? 'Anonymous Fan',
      userImage: map['userImage']?.toString() ?? '',
      text: map['text']?.toString() ?? '',
      targetId: map['targetId']?.toString() ?? '',
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] as Timestamp).toDate() 
          : null,
      likedBy: map['likedBy'] != null 
          ? List<String>.from(map['likedBy']) 
          : [],
    );
  }
}