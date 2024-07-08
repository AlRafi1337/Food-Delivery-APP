import '../models/revenue.dart';

class RevenueService {
  List<Revenue> getMonthlyRevenue() {
    // Ideally, this data should be fetched from a backend
    return Revenue.sampleRevenues;
  }
}
