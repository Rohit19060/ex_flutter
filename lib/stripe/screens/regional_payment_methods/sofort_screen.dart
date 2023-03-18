import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';
import '../../widgets/example_scaffold.dart';
import '../../widgets/loading_button.dart';

class SofortScreen extends StatefulWidget {
  const SofortScreen({super.key});

  @override
  State<SofortScreen> createState() => _SofortScreenState();
}

class _SofortScreenState extends State<SofortScreen> {
  Future<Map<String, dynamic>> _createPaymentIntent() async {
    final url = Uri.parse('$kApiUrl/create-payment-intent');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'currency': 'eur',
        'payment_method_types': ['sofort'],
        'amount': 1099
      }),
    );

    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<void> _pay(BuildContext context) async {
    // Precondition:
    //Make sure to have set a custom URI scheme in your app and add it to Stripe SDK
    // see file main.dart in this example app.
    // 1. on the backend create a payment intent for payment method and save the
    // client secret.
    final result = await _createPaymentIntent();
    final clientSecret = await result['clientSecret'];

    // 2. use the client secret to confirm the payment and handle the result.
    try {
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret.toString(),
        data: const PaymentMethodParams.sofort(
          paymentMethodData: PaymentMethodDataSofort(country: 'de'),
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment successfully completed')),
        );
      }
    } on Exception catch (e) {
      if (e is StripeException && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Error from Stripe: ${e.error.localizedMessage ?? e.error.code}')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Unforeseen error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) => ExampleScaffold(
        title: 'Sofort',
        tags: const ['Payment method'],
        padding: const EdgeInsets.all(16),
        children: [
          LoadingButton(
            onPressed: () async {
              await _pay(context);
            },
            text: 'Pay',
          ),
        ],
      );
}
