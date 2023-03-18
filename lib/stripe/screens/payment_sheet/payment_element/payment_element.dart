import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../config.dart';
import '../../../widgets/loading_button.dart';
import 'platforms/payment_element.dart'
    if (dart.library.js) 'platforms/payment_element_web.dart';

class PaymentElementExample extends StatefulWidget {
  const PaymentElementExample({super.key});

  @override
  State<PaymentElementExample> createState() => _ThemeCardExampleState();
}

class _ThemeCardExampleState extends State<PaymentElementExample> {
  String? clientSecret;

  @override
  void initState() {
    getClientSecret();
    super.initState();
  }

  Future<void> getClientSecret() async {
    try {
      final client = await createPaymentIntent();
      setState(() => clientSecret = client);
    } on Exception catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Flutter App'),
        ),
        body: Column(
          children: [
            Container(
                child: clientSecret != null
                    ? PlatformPaymentElement(clientSecret)
                    : const Center(child: CircularProgressIndicator())),
            const LoadingButton(onPressed: pay, text: 'Pay'),
          ],
        ),
      );

  Future<String> createPaymentIntent() async {
    final url = Uri.parse('$kApiUrl/create-payment-intent');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'currency': 'usd',
        'amount': 1099,
        'payment_method_types': ['card'],
        'request_three_d_secure': 'any',
      }),
    );
    final x = json.decode(response.body) as Map<String, dynamic>;
    return x['clientSecret'].toString();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('clientSecret', clientSecret));
  }
}
