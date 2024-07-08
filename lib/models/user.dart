import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String role;
  String username;

  UserModel(
      {required this.uid,
      required this.email,
      required this.role,
      required this.username});

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      uid: doc['uid'],
      email: doc['email'],
      role: doc['role'],
      username: doc['username'] ??
          doc['email'], // Default username is email if not set
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'username': username,
    };
  }
}
