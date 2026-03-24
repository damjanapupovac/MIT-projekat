import 'package:kpop_profiles/models/enums.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final String userImage;
  final UserRole role;
  final String? password;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.userImage,
    required this.role,
    this.password,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    UserRole assignedRole = UserRole.user;
    if (data['role'] == 'admin') {
      assignedRole = UserRole.admin;
    } else if (data['role'] == 'guest') {
      assignedRole = UserRole.guest;
    }

    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      userImage: data['userImage'] ?? '',
      role: assignedRole,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'userImage': userImage,
      'role': role == UserRole.admin ? 'admin' : (role == UserRole.guest ? 'guest' : 'user'),
    };
  }
}