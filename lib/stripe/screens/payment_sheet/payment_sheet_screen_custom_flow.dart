import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';
import '../../widgets/example_scaffold.dart';
import '../../widgets/loading_button.dart';

class PaymentSheetScreenWithCustomFlow extends StatefulWidget {
  const PaymentSheetScreenWithCustomFlow({super.key});

  @override
  State<PaymentSheetScreenWithCustomFlow> createState() =>
      _PaymentSheetScreenState();
}

class _PaymentSheetScreenState extends State<PaymentSheetScreenWithCustomFlow> {
  int step = 0;

  @override
  Widget build(BuildContext context) => ExampleScaffold(
        title: 'Payment Sheet',
        tags: const ['Custom Flow'],
        children: [
          Stepper(
            controlsBuilder: emptyControlBuilder,
            currentStep: step,
            steps: [
              Step(
                title: const Text('Init payment'),
                content: LoadingButton(
                  onPressed: initPaymentSheet,
                  text: 'Init payment sheet',
                ),
              ),
              Step(
                title: const Text('Select payment method'),
                content: LoadingButton(
                  onPressed: presentPaymentSheet,
                  text: 'Select payment method',
                ),
              ),
              Step(
                title: const Text('Confirm payment'),
                content: LoadingButton(
                  onPressed: confirmPayment,
                  text: 'Pay now',
                ),
              ),
            ],
          ),
        ],
      );

  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the server
      final data = await createTestPaymentSheet();

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Enable custom flow
          customFlow: true,
          // Main params
          merchantDisplayName: 'Flutter Stripe Store Demo',
          paymentIntentClientSecret: data['paymentIntent'] as String?,
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'] as String?,
          customerId: data['customer'] as String?,
          // Extra options
          applePay: const PaymentSheetApplePay(
            merchantCountryCode: 'DE',
          ),
          googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'DE'),
          style: ThemeMode.dark,
        ),
      );
      setState(() {
        step = 1;
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
      rethrow;
    }
  }

  Future<void> presentPaymentSheet() async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      setState(() => step = 2);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment option selected'),
          ),
        );
      }
    } on Exception catch (e) {
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unforeseen error: $e')),
        );
      }
    }
  }

  Future<void> confirmPayment() async {
    try {
      // 4. Confirm the payment sheet.
      await Stripe.instance.confirmPaymentSheetPayment();

      setState(() => step = 0);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment successfully completed')));
      }
    } on Exception catch (e) {
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Unforeseen error: $e')));
      }
    }
  }

  Future<Map<String, dynamic>> createTestPaymentSheet() async {
    final url = Uri.parse('$kApiUrl/payment-sheet');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'a': 'a'}),
    );
    final body = json.decode(response.body) as Map<String, dynamic>;
    if (body['error'] != null) {
      throw Exception('Error code: ${body['error']}');
    }
    return body;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('step', step));
  }
}

ControlsWidgetBuilder emptyControlBuilder = (_, __) => Container();
