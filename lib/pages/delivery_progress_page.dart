import "package:breeze_mobile/components/my_receipt.dart";
import "package:breeze_mobile/models/restaurant.dart";
import "package:breeze_mobile/services/database/firestore.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class DeliveryProgressPage extends StatefulWidget {
  const DeliveryProgressPage({super.key});

  @override
  State<DeliveryProgressPage> createState() => _DeliveryProgressPageState();
}

class _DeliveryProgressPageState extends State<DeliveryProgressPage> {
  // geta ccess to db
  FirestoreService db = FirestoreService();

  @override
  void initState() {
    super.initState();

    // this page will submit order to firestore db
    String receipt = context.read<Restaurant>().displayCartReceipt();
    db.saveOrderToDatabase(receipt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildTopNavBar(context),
      bottomNavigationBar: _buildBottomNavBar(context),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            MyReceipt(),
          ],
        ),
      ),
    );
  }

  AppBar _buildTopNavBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.home),
        onPressed: () {
          Navigator.of(context).pushNamed('/');
        },
      ),
    );
  }
}

Widget _buildBottomNavBar(BuildContext context) {
  return Container(
    height: 100,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
    ),
    padding: const EdgeInsets.all(25),
    child: Row(
      children: [
        // Profile Picture Driver
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(width: 10),
        // Driver details
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Muhammad Habibie",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Driver",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),

        const Spacer(),

        Row(
          children: [
            // message
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.message),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(width: 10),

            // call
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.call),
                color: Colors.green,
              ),
            ),
          ],
        )
      ],
    ),
  );
}
