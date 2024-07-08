// ignore_for_file: prefer_const_constructors

import 'package:breeze_mobile/pages/admin/owner_home/owner_mainpage_low_app_bar.dart';
import 'package:flutter/material.dart';

import '../owner_home/owner_mainpage_side_menu.dart';
import '../owner_home/owner_mainpage_up_app_bar.dart';
import 'order_dashboard_body.dart';

class OrderMainPage extends StatefulWidget {
  static Route route() => MaterialPageRoute(builder: (_) => OrderMainPage());
  const OrderMainPage({super.key});

  @override
  State<OrderMainPage> createState() => _OrderMainPageState();
}

class _OrderMainPageState extends State<OrderMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: OwnerSideMenu(),
      appBar: OwnerMainAppBar(),
      body: OrderPage(),
      bottomNavigationBar: OwnerBottomAppBar(),
    );
  }
}
