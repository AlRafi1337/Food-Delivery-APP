// ignore_for_file: avoid_print

import 'package:breeze_mobile/models/cart_item.dart';
import 'package:breeze_mobile/models/orders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'food.dart';

class Restaurant extends ChangeNotifier {
  // list of menu
  final Set<Food> _menu = {};

  // user cart
  final List<CartItem> _cart = [];

  // delivery address can change or update
  String _deliveryAddress = 'Center Point';

  // food note
  String _foodNote = '';

  //G E T T E R S
  Set<Food> get menu => _menu;

  List<CartItem> get cart => _cart;

  String get deliveryAddress => _deliveryAddress;

  String get foodNote => _foodNote;

  Restaurant() {
    initData();
  }

  //O P E R A T I O N S

  void initData() async {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      return;
    }

    try {
      var aa =
          await FirebaseFirestore.instance.collection("carts").doc(uid).get();
      var bb = aa.data();
      _cart.clear();
      _cart.addAll(UserCart.fromJson(bb).items);
    } catch (e) {
      print("load carts error:$e");
    }

    try {
      var aa = await FirebaseFirestore.instance.collection("products").get();
      var bb = aa.docs;
      for (var value in bb) {
        _menu.add(Food.fromJson(value.data()));
      }
    } catch (e) {
      print("load products error:$e");
    }
    notifyListeners();
  }

  // add to cart
  void addToCart(Food food, List<Addon> selectedAddons,
      [String foodNote = '']) {
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      bool isSameFood = item.food == food;
      bool isSameAddons =
          const ListEquality().equals(item.selectedAddons, selectedAddons);
      return isSameFood && isSameAddons;
    });

    if (cartItem != null) {
      cartItem.quantity++;
    } else {
      _cart.add(
        CartItem(food: food, selectedAddons: selectedAddons),
      );
    }

    _foodNote = foodNote;

    _saveCartData();

    notifyListeners();
  }

  void _saveCartData() async {
    try {
      var uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null && uid.isNotEmpty) {
        //  print(UserCart(items: _cart).toJson());
        await FirebaseFirestore.instance
            .collection("carts")
            .doc(uid)
            .set(UserCart(items: _cart).toJson());
        print("-----------");
        print("add success");
        print("-----------");
      } else {
        print("-----------");
        print("add error");
        print("-----------");
      }
    } catch (e) {
      print("-----------");
      print("add error:$e");
      print("-----------");
    }
  }

  // remove from cart
  void removeFromCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);
    if (cartIndex != -1) {
      if (_cart[cartIndex].quantity > 1) {
        _cart[cartIndex].quantity--;
      } else {
        _cart.removeAt(cartIndex);
      }
    }
    _saveCartData();

    notifyListeners();
  }

  // get total price of cart
  num getTotalPrice() {
    num total = 0.0;
    for (CartItem cartItem in _cart) {
      num itemTotal = cartItem.food.price;
      for (Addon addon in cartItem.selectedAddons) {
        itemTotal += addon.price;
      }
      total += itemTotal * cartItem.quantity;
    }
    return total;
  }

  // get total number of items in cart
  int getTotalItemCount() {
    int totalItemCount = 0;
    for (CartItem cartItem in _cart) {
      totalItemCount += cartItem.quantity;
    }
    return totalItemCount;
  }

  //clear cart
  void clearCart() {
    _cart.clear();
    _saveCartData();
    notifyListeners();
  }

  void addFood(Food food) {
    _menu.add(food);
    notifyListeners();
  }

  //update delivery address
  void updateDeliveryAddress(String newAddress) {
    _deliveryAddress = newAddress;
    notifyListeners();
  }

  // get current order for receipt
  FoodOrder getCurrentOrder() {
    return FoodOrder(
      items: _cart,
      orderDate: DateTime.now(),
      totalPrice: getTotalPrice().toDouble(),
      deliveryAddress: _deliveryAddress,
      foodNote: _foodNote,
    );
  }

  //H E L P E R S
  // generate a receipt
  String displayCartReceipt() {
    final receipt = StringBuffer();

    // Get current user's email
    User? user = FirebaseAuth.instance.currentUser;
    String? userEmail = user?.email ?? "";

    // Insert the email into the receipt
    receipt.writeln("Hi! $userEmail");
    receipt.writeln("Here is your receipt.");
    receipt.writeln();

    String formattedDate =
        DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());

    receipt.writeln(formattedDate);
    receipt.writeln();
    receipt.writeln("-----------");
    receipt.writeln("Order Details");
    receipt.writeln("-----------");

    for (final cartItem in _cart) {
      receipt.writeln(
          "${cartItem.quantity} x ${cartItem.food.name} - ${_formatPrice(cartItem.food.price)}");
      if (cartItem.selectedAddons.isNotEmpty) {
        receipt.writeln("Addons: ${_formatAddons(cartItem.selectedAddons)}");
      }
      receipt.writeln();
    }
    receipt.writeln("-----------");
    receipt.writeln();
    receipt.writeln("Total Items: ${getTotalItemCount()}");
    receipt.writeln("Total Price: ${_formatPrice(getTotalPrice())}");
    receipt.writeln("Delivery Address: $deliveryAddress");
    return receipt.toString();
  }

  // format double value into money
  String _formatPrice(num price) {
    return "RM${price.toStringAsFixed(2)}";
  }

  // format list of addons into a string summary
  String _formatAddons(List<Addon> addons) {
    return addons
        .map((addon) => "${addon.name} (${_formatPrice(addon.price)})")
        .join(", ");
  }
}
