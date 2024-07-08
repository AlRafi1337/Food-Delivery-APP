// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/orders.dart';

abstract class OrderService {
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  Future<FoodOrder?> addOrder(Map<String, dynamic> orderData);
  Future<List<FoodOrder>> getOrders();
  Future<FoodOrder?> getOrderById(String orderId);
  Future<void> updateOrder(String orderId, Map<String, dynamic> updatedData);
  Future<void> deleteOrder(String orderId);
  Future<List<FoodOrder>> getOrdersByDate(DateTime date);
}
