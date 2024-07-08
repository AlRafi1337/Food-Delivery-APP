// ignore_for_file: annotate_overrides, unnecessary_import, avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:breeze_mobile/models/food.dart';
import 'package:breeze_mobile/services/admin/menu_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

class MenuServiceFireStore implements AdminService {
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  Future<Food?> addProduct(Map<String, dynamic> item) async {
    try {
      String imageUrl = '';
      File? image = item['image'];
      Uint8List? webImage = item['webImage'];

      if (image != null || webImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('menu_images')
            .child('${DateTime.now().toIso8601String()}.jpg');
        if (kIsWeb && webImage != null) {
          await ref.putData(webImage);
        } else if (image != null) {
          await ref.putFile(image);
        }
        imageUrl = await ref.getDownloadURL();
      }

      var food = Food(
        name: item['name'],
        description: item['description'],
        imagePath: imageUrl,
        price: item['price'],
        category: FoodCategory.fromStr(item['category']),
        availableAddons: (item['addons'] as List)
            .map((addon) => Addon.fromJson(addon))
            .toList(),
      );

      await _store.collection('products').doc(food.name).set(food.toJson());

      return food;
    } catch (e) {
      print('Error uploading menu item: $e');
      return null;
    }
  }

  @override
  Future<List<Food>> getProducts() async {
    try {
      QuerySnapshot snapshot = await _store.collection('products').get();
      List<Food> products = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add the document ID to the data map
        return Food.fromJson(data);
      }).toList();
      for (var product in products) {
        print(product);
      }
      return products;
    } catch (e) {
      print('Error getting products: $e');
      return [];
    }
  }

  @override
  Future<Food?> getProductById(String productId) async {
    try {
      QuerySnapshot querySnapshot = await _store
          .collection('products')
          .where('name', isEqualTo: productId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot snapshot = querySnapshot.docs.first;
        return Food.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        print('Product with name $productId not found');
        return null;
      }
    } catch (e) {
      print('Error getting product by name: $e');
      return null;
    }
  }

  @override
  Future<void> updateProduct(
      String productId, Map<String, dynamic> updatedData) async {
    try {
      QuerySnapshot querySnapshot = await _store
          .collection('products')
          .where('name', isEqualTo: productId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot snapshot = querySnapshot.docs.first;
        await _store
            .collection('products')
            .doc(snapshot.id)
            .update(updatedData);
      } else {
        print('Product with name $productId not found');
      }
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  @override
  Future<void> deleteProduct(String productName) async {
    try {
      // Query Firestore collection to find the document with the matching name
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _store
          .collection('products')
          .where('name', isEqualTo: productName)
          .get();

      // Check if any document matches the query
      if (snapshot.docs.isNotEmpty) {
        // Delete the first document that matches the query (assuming product names are unique)
        final productId = snapshot.docs.first.id;
        await _store.collection('products').doc(productId).delete();
        print('Product deleted successfully');
      } else {
        print('Product with name $productName not found');
      }
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  @override
  Future<List<Food>> getProductsByCategory(FoodCategory category) async {
    try {
      QuerySnapshot snapshot = await _store
          .collection('products')
          .where('category', isEqualTo: FoodCategory.toStr(category))
          .get();
      List<Food> products = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add the document ID to the data map
        return Food.fromJson(data);
      }).toList();
      for (var product in products) {
        print(product);
      }
      return products;
    } catch (e) {
      print('Error getting products by category: $e');
      return [];
    }
  }
}



  // @override
  // Future<Food?> getProductById(String productId) async {
  //   try {
  //     DocumentSnapshot snapshot =
  //         await _store.collection('products').doc(productId).get();
  //     if (snapshot.exists) {
  //       return Food.fromJson(snapshot.data() as Map<String, dynamic>);
  //     } else {
  //       print('Product with ID $productId not found');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error getting product by ID: $e');
  //     return null;
  //   }
  // }
  // @override
  // Future<void> updateProduct(
  //     String productId, Map<String, dynamic> updatedData) async {
  //   try {
  //     await _store.collection('products').doc(productId).update(updatedData);
  //   } catch (e) {
  //     print('Error updating product: $e');
  //   }
  // }