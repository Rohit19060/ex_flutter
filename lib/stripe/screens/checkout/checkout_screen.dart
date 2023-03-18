import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_checkout/stripe_checkout.dart';

import '../../config.dart';
import '../../env.dart';
import '../../widgets/example_scaffold.dart';
import 'platforms/stripe_checkout.dart'
    if (dart.library.js) 'platforms/stripe_checkout_web.dart';

class CheckoutScreenExample extends StatefulWidget {
  const CheckoutScreenExample({super.key});

  @override
  State<CheckoutScreenExample> createState() => _CheckoutScreenExample();
}

class _CheckoutScreenExample extends State<CheckoutScreenExample> {
  @override
  Widget build(BuildContext context) => ExampleScaffold(
        title: 'Checkout Page',
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 120),
          Center(
            child: ElevatedButton(
              onPressed: getCheckout,
              child: const Text('Open Checkout'),
            ),
          )
        ],
      );

  Future<void> getCheckout() async {
    final sessionId = await _createCheckoutSession();
    if (mounted) {
      final result = await redirectToCheckout(
        context: context,
        sessionId: sessionId,
        publishableKey: stripePublishableKey,
        successUrl: 'https://checkout.stripe.dev/success',
        canceledUrl: 'https://checkout.stripe.dev/cancel',
      );
      if (mounted) {
        final text = result.when(
          success: () => 'Paid successfully',
          canceled: () => 'Checkout canceled',
          error: (e) => 'Error $e',
          redirected: () => 'Redirected successfully',
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(text)));
      }
    }
  }

  Future<String> _createCheckoutSession() async {
    final url = Uri.parse('$kApiUrl/create-checkout-session');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        if (kIsWeb) 'port': getUrlPort(),
      }),
    );
    final bodyResponse = json.decode(response.body) as Map<String, dynamic>;
    final id = bodyResponse['id'] as String;
    log('Checkout session id $id');
    return id;
  }
}
