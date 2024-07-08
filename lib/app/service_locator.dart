import 'package:breeze_mobile/pages/admin/owner_orders_page/order_viewmodel.dart';
import 'package:breeze_mobile/services/admin/menu_service.dart';
import 'package:breeze_mobile/services/admin/menu_service_firebase.dart';
import 'package:map_mvvm/app/service_locator.dart';

import '../pages/admin/admin_viewmodel.dart';
import '../services/payment/payment_sevice.dart';

final locator = ServiceLocator.locator;

void initializeServiceLocator() {
// Register Services
  locator.registerLazySingleton<AdminService>(() => MenuServiceFireStore());
  locator.registerLazySingleton<PaymentService>(() => PaymentService());
  locator.registerLazySingleton<AdminViewModel>(() => AdminViewModel());
  locator.registerLazySingleton<OrderViewModel>(() => OrderViewModel());
}
