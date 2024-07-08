// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, use_super_parameters

import 'package:breeze_mobile/app/routes.dart';
import 'package:flutter/material.dart';

class OwnerBottomAppBar extends StatefulWidget {
  const OwnerBottomAppBar({Key? key}) : super(key: key);

  @override
  State<OwnerBottomAppBar> createState() => _OwnerBottomAppBarState();
}

class _OwnerBottomAppBarState extends State<OwnerBottomAppBar> {
  late String orders = "Orders";
  late String menu = "Menu";
  late String list = "List";
  // late String profile = "Profile";
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    void _loadScreen() {
      switch (_currentIndex) {
        case 0:
          Navigator.pushNamed(context, Routes.home);
          return;
        case 1:
          Navigator.pushNamed(context, Routes.order_list);
          return;
        case 2:
          Navigator.pushNamed(context, Routes.owner_viewProduct);
          return;
        // case 2:
        //   Navigator.pushNamed(context, Routes.home);
        //   return;
      }
    }

    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() => _currentIndex = index);
        _loadScreen();
      },
      items: [
        BottomNavigationBarItem(
            label: orders, icon: Icon(Icons.receipt_long_outlined)),
        BottomNavigationBarItem(
          label: list,
          icon: Icon(Icons.list_alt_outlined),
        ),
        BottomNavigationBarItem(
          label: menu,
          icon: Icon(Icons.dashboard_outlined),
        ),
        // BottomNavigationBarItem(
        //   label: profile,
        //   icon: Icon(Icons.person_outline),
        // ),
      ],
    );
  }
}
