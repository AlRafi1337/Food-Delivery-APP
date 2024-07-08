import 'package:breeze_mobile/components/my_drawer_tile.dart';
import 'package:breeze_mobile/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/order_history_page.dart';
import '../pages/profile_pages.dart';
import '../pages/settings_page.dart';
import 'package:breeze_mobile/models/user.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    User? currentUser = AuthService().getCurrentUser();
    if (currentUser != null) {
      UserModel? user = await AuthService().getUserDetails(currentUser.uid);
      if (user != null) {
        setState(() {
          _user = user;
        });
      }
    }
  }

  void logout(BuildContext context) {
    final authService = AuthService();
    authService.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromRGBO(255, 166, 0, 1),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Icon(
              Icons.air_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          if (_user != null)
            Text(
              'Hi! ${_user!.username}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 30,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          MyDrawerTile(
            text: "HOME",
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
          ),
          MyDrawerTile(
            text: "SETTINGS",
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
          MyDrawerTile(
            text: "PROFILE",
            icon: Icons.person,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
          MyDrawerTile(
            text: "ORDER HISTORY",
            icon: Icons.history,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderHistoryPage(),
                ),
              );
            },
          ),
          const Spacer(),
          MyDrawerTile(
            text: "LOGOUT",
            icon: Icons.logout,
            onTap: () => logout(context),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
