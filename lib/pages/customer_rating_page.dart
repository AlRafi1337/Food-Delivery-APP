import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerRatingPage extends StatefulWidget {
  final String orderId;

  const CustomerRatingPage({super.key, required this.orderId});

  @override
  // ignore: library_private_types_in_public_api
  _CustomerRatingPageState createState() => _CustomerRatingPageState();
}

class _CustomerRatingPageState extends State<CustomerRatingPage> {
  final TextEditingController _feedbackController = TextEditingController();
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Your Experience'),
        backgroundColor: Color.fromRGBO(255, 166, 0, 1),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Rate our service:'),
            Slider(
              value: _rating,
              onChanged: (newRating) {
                setState(() {
                  _rating = newRating;
                });
              },
              min: 0,
              max: 5,
              divisions: 5,
              label: _rating.toString(),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                labelText: 'Feedback (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                submitRating();
              },
              child: const Text('Submit Rating'),
            ),
          ],
        ),
      ),
    );
  }

  void submitRating() async {
    try {
      await FirebaseFirestore.instance.collection('ratings').add({
        'orderId': widget.orderId,
        'rating': _rating,
        'feedback': _feedbackController.text,
        'timestamp': Timestamp.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Thank you for your feedback!'),
      ));
      Navigator.pop(context); // Navigate back to the order details page
    } catch (e) {
      print('Error submitting rating: $e');
      // Handle error
    }
  }
}
