// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/orders.dart';
import 'order_service.dart';

class OrderServiceImpl implements OrderService {
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  @override
  Future<FoodOrder?> addOrder(Map<String, dynamic> orderData) async {
    try {
      // Add the order data to the collection without an ID
      DocumentReference docRef =
          await _store.collection('myorders').add(orderData);

      // Fetch the document to ensure consistency and set the ID field in the data
      DocumentSnapshot docSnap = await docRef.get();
      Map<String, dynamic> orderWithId = docSnap.data() as Map<String, dynamic>;
      orderWithId['id'] = docRef.id;

      // Update the document with the generated ID
      await docRef.update({'id': docRef.id});

      // Return the FoodOrder object with the correct ID
      return FoodOrder.fromJson(orderWithId);
    } catch (e) {
      print('Error adding order: $e');
      return null;
    }
  }

  @override
  Future<List<FoodOrder>> getOrders() async {
    try {
      QuerySnapshot querySnapshot = await _store.collection('myorders').get();
      return querySnapshot.docs.map((doc) {
        // Create FoodOrder object and set the ID
        Map<String, dynamic> orderData = doc.data() as Map<String, dynamic>;
        orderData['id'] = doc.id;
        return FoodOrder.fromJson(orderData);
      }).toList();
    } catch (e) {
      print('Error getting orders: $e');
      return [];
    }
  }

  @override
  Future<FoodOrder?> getOrderById(String orderId) async {
    try {
      DocumentSnapshot docSnap =
          await _store.collection('myorders').doc(orderId).get();
      if (docSnap.exists) {
        Map<String, dynamic> orderData = docSnap.data() as Map<String, dynamic>;
        orderData['id'] = docSnap.id;
        return FoodOrder.fromJson(orderData);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting order by ID: $e');
      return null;
    }
  }

  @override
  Future<void> updateOrder(
      String orderId, Map<String, dynamic> updatedData) async {
    try {
      await _store.collection('myorders').doc(orderId).update(updatedData);
    } catch (e) {
      print('Error updating order: $e');
    }
  }

  @override
  Future<void> deleteOrder(String orderId) async {
    try {
      await _store.collection('myorders').doc(orderId).delete();
    } catch (e) {
      print('Error deleting order: $e');
    }
  }

  @override
  Future<List<FoodOrder>> getOrdersByDate(DateTime date) async {
    try {
      QuerySnapshot querySnapshot = await _store
          .collection('myorders')
          .where('orderDate', isEqualTo: date.toIso8601String())
          .get();
      return querySnapshot.docs.map((doc) {
        // Create FoodOrder object and set the ID
        Map<String, dynamic> orderData = doc.data() as Map<String, dynamic>;
        orderData['id'] = doc.id;
        return FoodOrder.fromJson(orderData);
      }).toList();
    } catch (e) {
      print('Error getting orders by date: $e');
      return [];
    }
  }
}
