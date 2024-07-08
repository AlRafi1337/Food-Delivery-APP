// ignore_for_file: prefer_const_constructors, deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';

import 'owner_mainpage_body.dart';
import 'owner_mainpage_low_app_bar.dart';
import 'owner_mainpage_side_menu.dart';
import 'owner_mainpage_up_app_bar.dart';

class OwnerMainPageScreen extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (_) => OwnerMainPageScreen());
  const OwnerMainPageScreen({Key? key}) : super(key: key);

  @override
  State<OwnerMainPageScreen> createState() => _OwnerMainPageScreenState();
}

class _OwnerMainPageScreenState extends State<OwnerMainPageScreen> {
  Future<bool?> warning(BuildContext context) async => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Are you sure to logout?'),
          actions: [
            ElevatedButton(
                child: Text('No'),
                onPressed: () => Navigator.pop(context, false)),
            ElevatedButton(
                child: Text('Yes'),
                onPressed: () async {
                  // String status = await viewmodel.signOutUser();
                  Navigator.pop(context, true);
                })
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        final shouldPop = await warning(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
        drawer: OwnerSideMenu(),
        appBar: OwnerMainAppBar(),
        body: SingleChildScrollView(
          child: OwnerMainPage(),
        ),
        bottomNavigationBar: OwnerBottomAppBar(),
      ));
}
