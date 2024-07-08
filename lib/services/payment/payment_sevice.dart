// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_card.dart';

class PaymentService {
  Future<void> saveCard({
    required String cardNumber,
    required String expiryDate,
    required String cardHolderName,
    required String cvvCode,
  }) async {
    try {
      var uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null || uid.isEmpty) {
        return;
      }
      await FirebaseFirestore.instance.collection("cards").doc(uid).set(
            UserCard(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
            ).toJson(),
          );
    } catch (e) {
      print(e);
    }
  }

  Future<UserCard> getCard() async {
    try {
      var uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null || uid.isEmpty) {
        return UserCard();
      }
      var res =
          await FirebaseFirestore.instance.collection("cards").doc(uid).get();
      return UserCard.fromJson(res.data());
    } catch (e) {
      print(e);
    }
    return UserCard();
  }
}
