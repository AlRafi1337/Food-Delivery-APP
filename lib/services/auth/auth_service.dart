// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<UserModel?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromDocument(doc);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to fetch user details: $e');
    }
  }

  // sign in
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign up with default role as customer
  Future<UserCredential> signUpWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save user data to Firestore with role 'customer'
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'role': 'customer', // Default role
        'created_at': FieldValue.serverTimestamp(),
        'username': email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception("Failed to create user: ${e.message}");
    }
  }

  // sign out
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception("Failed to send reset password email: ${e.message}");
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    User? user = _firebaseAuth.currentUser;
    String email = user!.email!;

    // Re-authenticate user
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // If re-authentication is successful, proceed to change the password
      await user.updatePassword(newPassword);
      print("Password changed successfully.");
    } on FirebaseAuthException catch (e) {
      print("Error changing password: ${e.message}");
      throw Exception(e.message);
    }
  }

  Future<void> updateUsername(String uid, String newUsername) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'username': newUsername,
      });
    } catch (e) {
      throw Exception('Failed to update username: $e');
    }
  }

  Future<void> deleteUserAccount() async {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      try {
        // Delete user data from Firestore
        await _firestore.collection('users').doc(user.uid).delete();

        // Delete user authentication account
        await user.delete();

        print("User account deleted successfully.");
      } on FirebaseAuthException catch (e) {
        print("Error deleting user account: ${e.message}");
        throw Exception(e.message);
      }
    } else {
      throw Exception("No user currently signed in.");
    }
  }
}
