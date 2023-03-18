import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../..//config.dart';
import '../..//utils.dart';
import '../..//widgets/example_scaffold.dart';
import '../..//widgets/loading_button.dart';
import '../..//widgets/response_card.dart';

class WebhookPaymentScreen extends StatefulWidget {
  const WebhookPaymentScreen({super.key});

  @override
  State<WebhookPaymentScreen> createState() => _WebhookPaymentScreenState();
}

class _WebhookPaymentScreenState extends State<WebhookPaymentScreen> {
  CardFieldInputDetails? _card;
  String _email = 'email@stripe.com';
  bool? _saveCard = false;

  @override
  Widget build(BuildContext context) => ExampleScaffold(
        title: 'Card Field',
        tags: const ['With Webhook'],
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          TextFormField(
            initialValue: _email,
            decoration:
                const InputDecoration(hintText: 'Email', labelText: 'Email'),
            onChanged: (value) {
              setState(() {
                _email = value;
              });
            },
          ),
          const SizedBox(height: 20),
          CardField(
            enablePostalCode: true,
            countryCode: 'US',
            postalCodeHintText: 'Enter the us postal code',
            onCardChanged: (card) {
              setState(() {
                _card = card;
              });
            },
          ),
          const SizedBox(height: 20),
          CheckboxListTile(
            value: _saveCard,
            onChanged: (value) {
              setState(() {
                _saveCard = value;
              });
            },
            title: const Text('Save card during payment'),
          ),
          LoadingButton(
            // ignore: use_if_null_to_convert_nulls_to_bools
            onPressed: _card?.complete == true ? _handlePayPress : null,
            text: 'Pay',
          ),
          const SizedBox(height: 20),
          if (_card != null)
            ResponseCard(
              response: _card!.toJson().toPrettyString(),
            ),
        ],
      );

  Future<void> _handlePayPress() async {
    if (_card == null) {
      return;
    }

    // 1. fetch Intent Client Secret from backend
    final clientSecret = await fetchPaymentIntentClientSecret();

    // 2. Gather customer billing information (ex. email)
    final billingDetails = BillingDetails(
      email: _email,
      phone: '+48888000888',
      address: const Address(
        city: 'Houston',
        country: 'US',
        line1: '1459  Circle Drive',
        line2: '',
        state: 'Texas',
        postalCode: '77063',
      ),
    ); // mo mocked data for tests

    // 3. Confirm payment with card details
    // The rest will be done automatically using webhooks
    // ignore: unused_local_variable
    final paymentIntent = await Stripe.instance.confirmPayment(
      paymentIntentClientSecret: clientSecret['clientSecret'].toString(),
      data: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(billingDetails: billingDetails),
      ),
      options: PaymentMethodOptions(
          setupFutureUsage:
              // ignore: use_if_null_to_convert_nulls_to_bools
              _saveCard == true ? PaymentIntentsFutureUsage.OffSession : null),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Success!: The payment was confirmed successfully!')));
    }
  }

  Future<Map<String, dynamic>> fetchPaymentIntentClientSecret() async {
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
    return json.decode(response.body) as Map<String, dynamic>;
  }
}
