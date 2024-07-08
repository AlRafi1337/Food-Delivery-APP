import 'package:map_mvvm/view/viewmodel.dart';

import '../../../models/orders.dart';
import '../../../services/order/order_service.dart';
import '../../../services/order/order_service_impl.dart';

class OrderViewModel extends Viewmodel {
  final OrderService _orderService = OrderServiceImpl();
  List<FoodOrder> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<FoodOrder> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get count => _orders.length;

  Future<String> addOrder(Map<String, dynamic> orderData) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      update();
      FoodOrder? newOrder = await _orderService.addOrder(orderData);
      if (newOrder != null) {
        _orders.add(newOrder);
        update();
        return 'Order has been added successfully';
      } else {
        return 'Failed to add order';
      }
    } catch (e) {
      _errorMessage = 'Error adding order: $e';
      return _errorMessage!;
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      update();
      await _orderService.deleteOrder(orderId);
      _orders.removeWhere((order) => order.id == orderId);
      update();
    } catch (e) {
      _errorMessage = 'Error deleting order: $e';
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<void> updateOrder(
      String orderId, Map<String, dynamic> updatedData) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      update();
      await _orderService.updateOrder(orderId, updatedData);
      int index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index] = FoodOrder.fromJson(updatedData);
        update();
      }
    } catch (e) {
      _errorMessage = 'Error updating order: $e';
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<void> getAllOrders() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      update();
      final list = await _orderService.getOrders();
      _orders = list;
    } catch (e) {
      _errorMessage = 'Error fetching orders: $e';
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<void> getOrderById(String orderId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      update();
      FoodOrder? order = await _orderService.getOrderById(orderId);
      if (order != null) {
        _orders = [order];
        update();
      }
    } catch (e) {
      _errorMessage = 'Error fetching order by ID: $e';
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<void> getOrdersByDate(DateTime date) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      update();
      final list = await _orderService.getOrdersByDate(date);
      _orders = list;
    } catch (e) {
      _errorMessage = 'Error fetching orders by date: $e';
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<List<FoodOrder>> getOrdersByStatus(OrderStatus status) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      update();
      final list = await _orderService.getOrders();
      _orders = list.where((order) => order.status == status).toList();
      return _orders;
    } catch (e) {
      _errorMessage = 'Error fetching orders by status: $e';
      return [];
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<FoodOrder?> updateOrderStatus(
      String? orderId, OrderStatus newStatus) async {
    if (orderId == null) {
      _errorMessage = 'Invalid order ID';
      notifyListeners();
      return null;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Fetch the order by ID
      FoodOrder? order = await _orderService.getOrderById(orderId);
      order?.printOrder();
      if (order != null) {
        // Update the status of the fetched order
        order.status = newStatus;
        // Call updateOrder to save changes
        await _orderService.updateOrder(orderId, order.toJson());
        // Update the order list in the view model
        int index = _orders.indexWhere((order) => order.id == orderId);
        if (index != -1) {
          _orders[index] = order;
          notifyListeners();
        }
        return order; // Return the updated order
      }
    } catch (e) {
      _errorMessage = 'Error updating order status: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return null;
  }

  @override
  void init() {
    getAllOrders();
    super.init();
  }
}
