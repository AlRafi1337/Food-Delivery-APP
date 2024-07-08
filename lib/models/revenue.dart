import 'package:flutter/material.dart';

class Revenue extends ChangeNotifier {
  final String month;
  final double amount;

  Revenue({
    required this.month,
    required this.amount,
  });

  // Mock data for demonstration
  static List<Revenue> sampleRevenues = [
    Revenue(month: 'January', amount: 12000),
    Revenue(month: 'February', amount: 15000),
    Revenue(month: 'March', amount: 13000),
    Revenue(month: 'April', amount: 14000),
  ];
}
