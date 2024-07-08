// ignore_for_file: avoid_print

import 'package:breeze_mobile/pages/admin/owner_orders_page/order_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:map_mvvm/view/view.dart';

import '../components/my_button.dart';
import '../models/cart_item.dart';
import '../models/orders.dart';
import '../models/user_card.dart';
import '../services/payment/payment_sevice.dart';
import 'delivery_progress_page.dart';

class PaymentPage extends StatefulWidget {
  final UserCard card;
  final List<CartItem> cart;

  const PaymentPage({super.key, required this.card, required this.cart});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  late PaymentService paymentService;

  @override
  void initState() {
    super.initState();
    cardNumber = widget.card.cardNumber;
    expiryDate = widget.card.expiryDate;
    cardHolderName = widget.card.cardHolderName;
    cvvCode = widget.card.cvvCode;
    paymentService = PaymentService();
  }

  void _userTappedPay(BuildContext context) {
    if (formKey.currentState!.validate()) {
      _showPaymentConfirmationDialog(context);
    }
  }

  void _showPaymentConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Payment"),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text("Card Number: $cardNumber"),
              Text("Expiry Date: $expiryDate"),
              Text("Card Holder Name: $cardHolderName"),
              Text("CVV Code: $cvvCode"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ViewWrapper<OrderViewModel>(
            builder: (_, viewModel) => TextButton(
              onPressed: () => _submitData(context, viewModel),
              child: const Text("Yes"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitData(
      BuildContext context, OrderViewModel viewModel) async {
    final orderData = FoodOrder(
      items: widget.cart,
      orderDate: DateTime.now(),
      totalPrice: widget.cart.fold(
        0.0,
        (sum, item) => sum + item.totalPrice,
      ),
      deliveryAddress: '',
      foodNote: '',
    ).toJson();

    String resultMessage;

    try {
      resultMessage = await viewModel.addOrder(orderData);
      await paymentService.saveCard(
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cardHolderName: cardHolderName,
        cvvCode: cvvCode,
      );
      if (!context.mounted) return;
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DeliveryProgressPage(),
        ),
      );
    } catch (e) {
      resultMessage = 'Error: $e';
    }

    // Display a message to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(resultMessage)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Checkout"),
      ),
      body: Column(
        children: [
          CreditCardWidget(
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            showBackView: isCvvFocused,
            onCreditCardWidgetChange: (p0) {},
          ),
          CreditCardForm(
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            onCreditCardModelChange: (data) {
              setState(() {
                cardNumber = data.cardNumber;
                expiryDate = data.expiryDate;
                cardHolderName = data.cardHolderName;
                cvvCode = data.cvvCode;
              });
            },
            formKey: formKey,
          ),
          const Spacer(),
          MyButton(
            text: "Pay Now",
            onTap: () => _userTappedPay(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
