// import 'package:uuid/uuid.dart';

// import 'cart_item.dart';

// class FoodOrder {
//   String? id; // Firestore document ID
//   late List<CartItem> items;
//   late DateTime orderDate;
//   late double totalPrice;
//   late String deliveryAddress;
//   late String foodNote; // New field for special instructions

//   FoodOrder({
//     String? id,
//     required this.items,
//     required this.orderDate,
//     required this.totalPrice,
//     required this.deliveryAddress,
//     required this.foodNote,
//   }) : id = id ?? Uuid().v4();

//   String? get orderId => id;
//   List<CartItem> get orderItems => List.unmodifiable(items);
//   DateTime get orderDateTime => orderDate;
//   double get orderTotalPrice => totalPrice;
//   String? get orderFoodNote => foodNote;

//   FoodOrder.fromJson(Map<String, dynamic> json) {
//     id = json['id'] ?? Uuid().v4();
//     items =
//         (json['items'] as List).map((item) => CartItem.fromJson(item)).toList();
//     orderDate = DateTime.parse(json['orderDate']);
//     totalPrice = json['totalPrice'];
//     deliveryAddress = json['deliveryAddress'];
//     foodNote = json['foodNote'];
//   }

// ignore_for_file: avoid_print, prefer_const_constructors

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'items': items.map((item) => item.toJson()).toList(),
//       'orderDate': orderDate.toIso8601String(),
//       'totalPrice': totalPrice,
//       'deliveryAddress': deliveryAddress,
//       'foodNote': foodNote,
//     };
//   }
// }
import 'package:uuid/uuid.dart';

import 'cart_item.dart';

enum OrderStatus { pending, completed, cancelled }

class FoodOrder {
  String? id; // Firestore document ID
  late List<CartItem> items;
  late DateTime orderDate;
  late double totalPrice;
  late String deliveryAddress;
  late String foodNote; // New field for special instructions
  late OrderStatus status; // Optional field for order status

  FoodOrder({
    String? id,
    required this.items,
    required this.orderDate,
    required this.totalPrice,
    required this.deliveryAddress,
    required this.foodNote,
    OrderStatus? status, // Optional parameter
  })  : id = id ?? Uuid().v4(),
        status = status ?? OrderStatus.pending; // Default value if not provided

  String? get orderId => id;
  List<CartItem> get orderItems => List.unmodifiable(items);
  DateTime get orderDateTime => orderDate;
  double get orderTotalPrice => totalPrice;
  String? get orderFoodNote => foodNote;
  OrderStatus get orderStatus => status;
  void printOrder() {
    print('Order ID: $id');
    print('Order Date: $orderDate');
    print('Total Price: $totalPrice');
    print('Delivery Address: $deliveryAddress');
    print('Food Note: $foodNote');
    print('Status: $status');
    print('Items:');
    for (var item in items) {
      print('  - ${item.food.name} (Quantity: ${item.quantity})');
    }
  }

  FoodOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? Uuid().v4();
    items =
        (json['items'] as List).map((item) => CartItem.fromJson(item)).toList();
    orderDate = DateTime.parse(json['orderDate']);
    totalPrice = json['totalPrice'];
    deliveryAddress = json['deliveryAddress'];
    foodNote = json['foodNote'];
    status = json['status'] != null
        ? OrderStatus.values
            .firstWhere((e) => e.toString() == 'OrderStatus.${json['status']}')
        : OrderStatus.pending; // Default value if not provided in JSON
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'orderDate': orderDate.toIso8601String(),
      'totalPrice': totalPrice,
      'deliveryAddress': deliveryAddress,
      'foodNote': foodNote,
      'status': status.toString().split('.').last, // Store as string
    };
  }
}
