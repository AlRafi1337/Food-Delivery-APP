import 'package:breeze_mobile/pages/home_page.dart';
import 'package:breeze_mobile/services/auth/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../pages/admin/owner_orders_page/order_mainpage.dart';
import 'auth_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final User user = snapshot.data!;
            return FutureBuilder<UserModel?>(
              future: authService.getUserDetails(user.uid),
              builder:
                  (context, AsyncSnapshot<UserModel?> userDetailsSnapshot) {
                if (userDetailsSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (userDetailsSnapshot.hasData) {
                  final UserModel userModel = userDetailsSnapshot.data!;
                  if (userModel.role == 'admin') {
                    return const OrderMainPage();
                  } else {
                    return const HomePage();
                  }
                } else {
                  return const LoginOrRegister();
                }
              },
            );
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
