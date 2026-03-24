import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kpop_profiles/models/enums.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? _user;
  String _username = '';
  String _email = '';
  String _userImage = '';
  UserRole _role = UserRole.guest;

  bool get isLoggedIn => _user != null;
  UserRole get role => _role;
  bool get isAdmin => _role == UserRole.admin;
  String get username => _username;
  String get email => _email;
  String get userImage => _userImage;
  User? get user => _user;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      if (user != null) {
        await _fetchUserData(user.uid);
      } else {
        _resetData();
      }
      notifyListeners();
    });
  }

  void _resetData() {
    _username = '';
    _email = '';
    _userImage = '';
    _role = UserRole.guest;
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        _username = data['username'] ?? '';
        _email = data['email'] ?? '';
        _userImage = data['userImage'] ?? '';
        _role = data['role'] == 'admin' ? UserRole.admin : UserRole.user;
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String username,
    File? imageFile,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String imageUrl = '';
      if (imageFile != null) {
        imageUrl = await _uploadImage(imageFile, result.user!.uid) ?? '';
      }

      await result.user!.updateDisplayName(username);
      await result.user!.updatePhotoURL(imageUrl);

      await _db.collection('users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        'email': email,
        'username': username,
        'role': 'user',
        'userImage': imageUrl,
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _resetData();
    notifyListeners();
  }

  Future<String?> _uploadImage(File imageFile, String uid) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('$uid.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUserData({
    required String username,
    String? imagePath,
    String? newPassword,
  }) async {
    if (_user == null) return;
    try {
      String imageUrl = _userImage;
      if (imagePath != null) {
        imageUrl =
            await _uploadImage(File(imagePath), _user!.uid) ?? _userImage;
      }

      await _user!.updateDisplayName(username);
      await _user!.updatePhotoURL(imageUrl);

      await _db.collection('users').doc(_user!.uid).update({
        'username': username,
        'userImage': imageUrl,
      });

      if (newPassword != null && newPassword.isNotEmpty) {
        await _user!.updatePassword(newPassword);
      }

      _username = username;
      _userImage = imageUrl;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
