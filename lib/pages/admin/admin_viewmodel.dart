// import 'package:map_mvvm/view/viewmodel.dart';

// import '../../models/food.dart';
// import '../../services/admin/admin_service.dart';
// import '../../services/admin/admin_service_firebase.dart';

// class AdminViewModel extends Viewmodel {
//   final AdminService _adminService = AdminServiceFirebase();
//   List<Food> _products = [];
//   bool _isLoading = false;
//   String? _errorMessage;

//   List<Food> get products => _products;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   int get count => _products.length;

//   Future<void> addProduct(Map<String, dynamic> item) async {
//     Food? newProduct = await _adminService.addProduct(item);
//     if (newProduct != null) {
//       _products.add(newProduct);
//       update();
//     }
//   }

//   Future<void> deleteProduct(String productName) async {
//     await _adminService.deleteProduct(productName);
//     _products.removeWhere((product) => product.name == productName);
//     update();
//   }

//   Future<void> updateProduct(
//       String productId, Map<String, dynamic> updatedData) async {
//     await _adminService.updateProduct(productId, updatedData);
//     int index = _products.indexWhere((product) => product.name == productId);
//     if (index != -1) {
//       _products[index] = await _adminService.getProductById(productId) as Food;
//       update();
//     }
//   }

//   Future<void> getAllProducts() async {
//     try {
//       _isLoading = true;
//       _errorMessage = null;
//       update();
//       final list = await _adminService.getProducts();
//       _products = list;
//     } catch (e) {
//       _errorMessage = 'Error fetching data';
//     } finally {
//       _isLoading = false;
//       update();
//     }
//   }

//   Future<void> getProductsByCategory(FoodCategory category) async {
//     try {
//       _isLoading = true;
//       _errorMessage = null;
//       update();
//       final list = await _adminService.getProductsByCategory(category);
//       _products = list;
//     } catch (e) {
//       _errorMessage = 'Error fetching data';
//     } finally {
//       _isLoading = false;
//       update();
//     }
//   }

//   @override
//   void init() {
//     getAllProducts();
//     super.init();
//   }
// }
import 'package:map_mvvm/view/viewmodel.dart';

import '../../models/food.dart';
import '../../services/admin/menu_service.dart';
import '../../services/admin/menu_service_firebase.dart';

class AdminViewModel extends Viewmodel {
  final AdminService _adminService = MenuServiceFireStore();
  List<Food> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Food> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get count => _products.length;

  Future<void> addProduct(Map<String, dynamic> item) async {
    Food? newProduct = await _adminService.addProduct(item);
    if (newProduct != null) {
      _products.add(newProduct);
      update();
    }
  }

  Future<void> deleteProduct(String productName) async {
    await _adminService.deleteProduct(productName);
    _products.removeWhere((product) => product.name == productName);
    update();
  }

  Future<void> updateProduct(
      String productName, Map<String, dynamic> updatedData) async {
    await _adminService.updateProduct(productName, updatedData);
    int index = _products.indexWhere((product) => product.name == productName);
    if (index != -1) {
      _products[index] = Food.fromMap(
          updatedData); // Create a new Food object from the updated data
      update();
    }
  }

  Future<void> getAllProducts() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      update();
      final list = await _adminService.getProducts();
      _products = list;
    } catch (e) {
      _errorMessage = 'Error fetching data';
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<void> getProductsByCategory(FoodCategory category) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      update();
      final list = await _adminService.getProductsByCategory(category);
      _products = list;
    } catch (e) {
      _errorMessage = 'Error fetching data';
    } finally {
      _isLoading = false;
      update();
    }
  }

  @override
  void init() {
    getAllProducts();
    super.init();
  }
}
  // Future<void> updateProduct(
  //     String productName, Map<String, dynamic> updatedData) async {
  //   await _adminService.updateProduct(productName, updatedData);

  //   int index = _products.indexWhere((product) => product.name == productName);
  //   if (index != -1) {
  //     _products[index] =
  //         await _adminService.updateProduct(productName, updatedData) as Food;
  //     update();
  //   }
  // }