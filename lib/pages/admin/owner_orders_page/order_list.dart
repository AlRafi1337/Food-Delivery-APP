// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_super_parameters, use_build_context_synchronously, avoid_print, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'package:breeze_mobile/pages/admin/owner_home/owner_mainpage_low_app_bar.dart';
import 'package:breeze_mobile/pages/admin/owner_home/owner_mainpage_side_menu.dart';
import 'package:breeze_mobile/pages/admin/owner_home/owner_mainpage_up_app_bar.dart';
import 'package:breeze_mobile/pages/admin/owner_orders_page/order_listbody.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class OrderListPage extends StatefulWidget {
  static Route route() => MaterialPageRoute(builder: (_) => OrderListPage());
  const OrderListPage({Key? key}) : super(key: key);

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: OwnerSideMenu(),
      appBar: OwnerMainAppBar(),
      body: OrderListbody(),
      bottomNavigationBar: OwnerBottomAppBar(),
    );
  }
}
