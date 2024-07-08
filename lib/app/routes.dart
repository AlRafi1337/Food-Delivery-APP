// ignore_for_file: constant_identifier_names, dead_code

import 'package:breeze_mobile/pages/admin/owner_menu/owner_dashboard_screen.dart';
import 'package:breeze_mobile/pages/admin/owner_notification/notification_main.dart';
import 'package:breeze_mobile/pages/admin/owner_orders_page/order_list.dart';
import 'package:breeze_mobile/pages/admin/owner_orders_page/order_mainpage.dart';
import 'package:flutter/material.dart';

import '../pages/admin/owner_home/owner_add_product.dart';
import '../pages/admin/revenue_screen.dart';

// This routes.dart has not been used yet in this version.
// The app is still not using named routes.

class Routes {
  static const String home = '/';
  static const String edit = '/edit';
  static const String owner_addProduct = '/addproduct';
  static const String owner_viewProduct = '/viewproduct';
  static const String owner_viewOrders = '/vieworders';
  static const String revenue = '/revenue';
  static const String order_list = '/orderlist';
  static const String notification = '/notification';

  static Route<dynamic>? createRoutes(RouteSettings? settings) {
    switch (settings?.name) {
      case home:
        return createRoutes(settings);

      case edit:
        return createRoutes(settings);
      case owner_addProduct:
        return AddProductToMenu.route();
      case owner_viewProduct:
        return OwnerDashboardScreen.route();
      case owner_viewOrders:
        return OrderMainPage.route();
      case revenue:
        return MaterialPageRoute(builder: (context) => RevenueScreen());
      case order_list:
        return OrderListPage.route();
      case notification:
        return NotificationsPage.route();

      default:
        throw const FormatException('route not found');
    }
    return null;
  }
}
