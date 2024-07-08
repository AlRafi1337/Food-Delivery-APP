import 'food.dart';

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

  Food get itemFood => food;
  List<Addon> get itemSelectedAddons => List.unmodifiable(selectedAddons);
  int get itemQuantity => quantity;

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
    data["selectedAddons"] = selectedAddons.map((e) => e.toJson()).toList();
    return data;
  }
}
