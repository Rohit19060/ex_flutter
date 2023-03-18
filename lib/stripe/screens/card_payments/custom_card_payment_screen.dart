import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';
import '../../widgets/loading_button.dart';

class CustomCardPaymentScreen extends StatefulWidget {
  const CustomCardPaymentScreen({super.key});

  @override
  State<CustomCardPaymentScreen> createState() =>
      _CustomCardPaymentScreenState();
}

class _CustomCardPaymentScreenState extends State<CustomCardPaymentScreen> {
  CardDetails _card = CardDetails();
  bool? _saveCard = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                      "If you don't want to or can't rely on the CardField you"
                      ' can use the dangerouslyUpdateCardDetails in combination with '
                      'your own card field implementation. \n\n'
                      'Please beware that this will potentially break PCI compliance: '
                      'https://stripe.com/docs/security/guide#validating-pci-compliance')),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        decoration: const InputDecoration(hintText: 'Number'),
                        onChanged: (number) {
                          setState(() {
                            _card = _card.copyWith(number: number);
                          });
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      width: 80,
                      child: TextField(
                        decoration:
                            const InputDecoration(hintText: 'Exp. Year'),
                        onChanged: (number) {
                          setState(() {
                            _card = _card.copyWith(
                                expirationYear: int.tryParse(number));
                          });
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      width: 80,
                      child: TextField(
                        decoration:
                            const InputDecoration(hintText: 'Exp. Month'),
                        onChanged: (number) {
                          setState(() {
                            _card = _card.copyWith(
                                expirationMonth: int.tryParse(number));
                          });
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      width: 80,
                      child: TextField(
                        decoration: const InputDecoration(hintText: 'CVC'),
                        onChanged: (number) {
                          setState(() {
                            _card = _card.copyWith(cvc: number);
                          });
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),
              CheckboxListTile(
                value: _saveCard,
                onChanged: (value) {
                  setState(() {
                    _saveCard = value;
                  });
                },
                title: const Text('Save card during payment'),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: LoadingButton(
                  onPressed: _handlePayPress,
                  text: 'Pay',
                ),
              ),
            ],
          ),
        ),
      );

  Future<void> _handlePayPress() async {
    await Stripe.instance.dangerouslyUpdateCardDetails(_card);

    try {
      // 1. Gather customer billing information (ex. email)

      const billingDetails = BillingDetails(
        email: 'email@stripe.com',
        phone: '+48888000888',
        address: Address(
          city: 'Houston',
          country: 'US',
          line1: '1459  Circle Drive',
          line2: '',
          state: 'Texas',
          postalCode: '77063',
        ),
      ); // mocked data for tests

      // 2. Create payment method
      final paymentMethod = await Stripe.instance.createPaymentMethod(
          params: const PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(
          billingDetails: billingDetails,
        ),
      ));

      // 3. call API to create PaymentIntent
      final paymentIntentResult = await callNoWebhookPayEndpointMethodId(
        useStripeSdk: true,
        paymentMethodId: paymentMethod.id,
        currency: 'usd', // mocked data
        items: [
          'id-1',
        ],
      );

      if (paymentIntentResult['error'] != null && mounted) {
        // Error during creating or confirming Intent
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${paymentIntentResult['error']}')));
        return;
      }

      if (paymentIntentResult['clientSecret'] != null &&
          paymentIntentResult['requiresAction'] == null &&
          mounted) {
        // Payment succeeded
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('Success!: The payment was confirmed successfully!')));
        return;
      }

      if (paymentIntentResult['clientSecret'] != null &&
          paymentIntentResult['requiresAction'] == true) {
        // 4. if payment requires action calling handleNextAction
        final paymentIntent = await Stripe.instance
            .handleNextAction(paymentIntentResult['clientSecret'].toString());

        if (paymentIntent.status == PaymentIntentsStatus.RequiresConfirmation) {
          // 5. Call API to confirm intent
          await confirmIntent(paymentIntent.id);
        } else if (mounted) {
          // Payment succeeded
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error: ${paymentIntentResult['error']}')));
        }
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
      rethrow;
    }
  }

  Future<void> confirmIntent(String paymentIntentId) async {
    final result = await callNoWebhookPayEndpointIntentId(
        paymentIntentId: paymentIntentId);
    if (result['error'] != null && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${result['error']}')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Success!: The payment was confirmed successfully!')));
    }
  }

  Future<Map<String, dynamic>> callNoWebhookPayEndpointIntentId({
    required String paymentIntentId,
  }) async {
    final url = Uri.parse('$kApiUrl/charge-card-off-session');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'paymentIntentId': paymentIntentId}),
    );
    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> callNoWebhookPayEndpointMethodId({
    required bool useStripeSdk,
    required String paymentMethodId,
    required String currency,
    List<String>? items,
  }) async {
    final url = Uri.parse('$kApiUrl/pay-without-webhooks');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'useStripeSdk': useStripeSdk,
        'paymentMethodId': paymentMethodId,
        'currency': currency,
        'items': items
      }),
    );
    return json.decode(response.body) as Map<String, dynamic>;
  }
}
