class Food {
  late String name;
  late String description;
  late String imagePath;
  late num price;
  late FoodCategory category;
  late List<Addon> availableAddons;

  Food({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.category,
    required this.availableAddons,
  });

  Food.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    description = json['description'] ?? '';
    imagePath = json['imagePath'] ?? '';
    price = json['price'] ?? 0;
    category = FoodCategory.fromStr(json['category'] ?? '');
    availableAddons = [];
    var aa = json['availableAddons'];
    if (aa is List<dynamic>) {
      for (var value in aa) {
        availableAddons.add(Addon.fromJson(value));
      }
    }
  }

  Food.fromMap(Map<String, dynamic> map) {
    name = map['name'] ?? '';
    description = map['description'] ?? '';
    imagePath = map['imagePath'] ?? '';
    price = map['price'] ?? 0;
    category = FoodCategory.values[map['category']];
    availableAddons = [];
    var aa = map['availableAddons'];
    if (aa is List<dynamic>) {
      for (var value in aa) {
        availableAddons.add(Addon.fromMap(value));
      }
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["name"] = name;
    data["description"] = description;
    data["imagePath"] = imagePath;
    data["price"] = price;
    data["category"] = FoodCategory.toStr(category);
    data["availableAddons"] = availableAddons.map((e) => e.toJson()).toList();
    return data;
  }
}

enum FoodCategory {
  rice,
  noodles,
  sides,
  drinks;

  static String toStr(FoodCategory foodCategory) {
    switch (foodCategory) {
      case rice:
        return "rice";
      case noodles:
        return "noodles";
      case sides:
        return "sides";
      case drinks:
        return "drinks";
    }
  }

  static FoodCategory fromStr(String foodCategory) {
    switch (foodCategory) {
      case 'rice':
        return rice;
      case 'noodles':
        return noodles;
      case 'sides':
        return sides;
      case 'drinks':
        return drinks;
      default:
        throw ArgumentError('Invalid food category: $foodCategory');
    }
  }
}

class Addon {
  late String name;
  late num price;

  Addon({
    required this.name,
    required this.price,
  });

  Addon.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
  }

  Addon.fromMap(Map<String, dynamic> map) {
    name = map['name'] ?? '';
    price = map['price'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["name"] = name;
    data["price"] = price;
    return data;
  }
}
