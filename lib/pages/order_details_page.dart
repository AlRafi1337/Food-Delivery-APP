import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'customer_rating_page.dart'; // Import the rating page

class OrderDetailsPage extends StatelessWidget {
  final String orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: const Color.fromRGBO(255, 166, 0, 1),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('myorders')
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Order not found.'));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order ID: ${snapshot.data!.id}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Order Date: ${data['orderDate']}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Items:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4.0),
                _buildItemsList(data['items']),
                const SizedBox(height: 4.0),
                Text(
                  'Delivery Address: ${data['deliveryAddress']}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Total Price: ${data['totalPrice']}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Status: ${data['status']}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CustomerRatingPage(orderId: orderId),
                      ),
                    );
                  },
                  child: const Text('Rate this Order'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemsList(List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        var food = item['food'];
        var addons = item['selectedAddons'] as List<dynamic>;
        var addonsStr = addons
            .map((addon) => "${addon['name']} (${addon['price']})")
            .join(', ');

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Image.network(
                food['imagePath'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${item['quantity']} x ${food['name']} - RM${food['price']}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (addons.isNotEmpty)
                      Text(
                        "Addons: $addonsStr",
                        style: const TextStyle(
                            fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
