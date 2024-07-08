import 'package:flutter/material.dart';

class OwnerDashboardScreen extends StatelessWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => OwnerDashboardScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/revenue');
          },
          child: Text('View Monthly Revenue'),
        ),
      ),
    );
  }
}
