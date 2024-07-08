// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/food.dart';

abstract class AdminService {
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  Future<Food?> addProduct(Map<String, dynamic> item);
  Future<List<Food>> getProducts();
  Future<Food?> getProductById(String productId);
  Future<void> updateProduct(
      String productId, Map<String, dynamic> updatedData);
  Future<void> deleteProduct(String productId);
  Future<List<Food>> getProductsByCategory(FoodCategory category);
}
