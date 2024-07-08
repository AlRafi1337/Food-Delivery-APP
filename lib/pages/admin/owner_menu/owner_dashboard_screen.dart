// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'package:flutter/material.dart';

import '../owner_home/owner_mainpage_low_app_bar.dart';
import '../owner_home/owner_mainpage_side_menu.dart';
import '../owner_home/owner_mainpage_up_app_bar.dart';
import 'owner_dashboard_body.dart';

class OwnerDashboardScreen extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (_) => OwnerDashboardScreen());
  const OwnerDashboardScreen({Key? key}) : super(key: key);

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreen();
}

class _OwnerDashboardScreen extends State<OwnerDashboardScreen> {
  @override
  Widget build(BuildContext context) => (Scaffold(
        drawer: OwnerSideMenu(),
        appBar: OwnerMainAppBar(),
        body: OwnerDashboardBodyPage(),
        bottomNavigationBar: OwnerBottomAppBar(),
      ));
}
