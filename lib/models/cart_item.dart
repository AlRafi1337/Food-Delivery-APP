import 'package:breeze_mobile/models/food.dart';

class UserCart {
  late List<CartItem> items;

  UserCart({
    required this.items,
  });

  UserCart.fromJson(Map<String, dynamic>? json) {
    items = [];
    if (json != null) {
      var aa = json['items'];
      if (aa is List<dynamic>) {
        for (var value in aa) {
          items.add(CartItem.fromJson(value));
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["items"] = items.map((e) => e.toJson());
    return data;
  }
}

class CartItem {
  late Food food;
  late List<Addon> selectedAddons;
  late int quantity;

  CartItem({
    required this.food,
    required this.selectedAddons,
    this.quantity = 1,
  });

  double get totalPrice {
    double addonPrice =
        selectedAddons.fold(0, (sum, addon) => sum + addon.price);
    return (food.price + addonPrice) * quantity;
  }

  CartItem.fromJson(Map<String, dynamic> json) {
    food = Food.fromJson(json['food']);
    quantity = json['quantity'];
    selectedAddons = [];
    var aa = json['selectedAddons'];
    if (aa is List<dynamic>) {
      for (var value in aa) {
        selectedAddons.add(Addon.fromJson(value));
      }
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["food"] = food.toJson();
    data["quantity"] = quantity;
    data["selectedAddons"] = selectedAddons.map((e) => e.toJson());
    return data;
  }
}
