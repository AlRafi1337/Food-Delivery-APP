import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../models/revenue.dart';
import '../../services/revenue_service.dart';

class RevenueScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final revenueService = RevenueService();
    final monthlyRevenue = revenueService.getMonthlyRevenue();

    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Revenue'),
      ),
      body: ListView.builder(
        itemCount: monthlyRevenue.length,
        itemBuilder: (context, index) {
          final revenue = monthlyRevenue[index];
          return ListTile(
            title: Text('${revenue.month}'),
            subtitle: Text('Revenue: \$${revenue.amount.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
