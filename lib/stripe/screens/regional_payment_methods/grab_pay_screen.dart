import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';
import '../../widgets/example_scaffold.dart';
import '../../widgets/loading_button.dart';

class GrabPayScreen extends StatefulWidget {
  const GrabPayScreen({super.key});

  @override
  State<GrabPayScreen> createState() => _GrabPayScreenState();
}

class _GrabPayScreenState extends State<GrabPayScreen> {
  Future<Map<String, dynamic>> _createPaymentIntent() async {
    final url = Uri.parse('$kApiUrl/create-payment-intent');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'currency': 'myr',
        'payment_method_types': ['grabpay'],
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

    // 2. create some billing details
    const billingDetails = BillingDetails(
      email: 'email@stripe.com',
      phone: '+60123456789',
      address: Address(
        city: 'Kuala Lumpur',
        country: 'MY',
        line1: 'Concourse Level',
        line2: '',
        state: '',
        postalCode: '50088',
      ),
    ); // mocked data for tests

    // 3. use the client secret to confirm the payment and handle the result.
    try {
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret.toString(),
        data: const PaymentMethodParams.grabPay(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment successfully completed'),
          ),
        );
      }
    } on Exception catch (e) {
      if (e is StripeException && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unforeseen error: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => ExampleScaffold(
        title: 'GrabPay',
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
