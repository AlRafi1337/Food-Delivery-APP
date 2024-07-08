// notification_body.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        foregroundColor: Color.fromRGBO(255, 255, 255, 1),
        backgroundColor: Color.fromRGBO(200, 118, 22, 1),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('myorders').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No new orders.'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length * 2 - 1, // Count for items and dividers
            itemBuilder: (context, index) {
              if (index.isOdd) {
                return Divider();
              }

              final orderIndex = index ~/ 2;
              var data = orders[orderIndex].data() as Map<String, dynamic>;

              return ListTile(
                title: Text('Order ID: ${orders[orderIndex].id}'),
                subtitle: _buildItemsList(data['items']),
                trailing: Text('Order Date: ${data['orderDate']}'),
                onTap: () {
                  // Navigate to order details page if needed
                },
              );
            },
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
