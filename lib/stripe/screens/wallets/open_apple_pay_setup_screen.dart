import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../widgets/example_scaffold.dart';

class OpenApplePaySetup extends StatefulWidget {
  const OpenApplePaySetup({super.key});

  @override
  State<OpenApplePaySetup> createState() => _OpenApplePaySetupState();
}

class _OpenApplePaySetupState extends State<OpenApplePaySetup> {
  Future<void> openApplePaySetup() async {
    await Stripe.instance.openApplePaySetup();
  }

  @override
  Widget build(BuildContext context) => ExampleScaffold(
        title: 'Open Apple pay Setup',
        tags: const ['iOS'],
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: ElevatedButton(
                onPressed: openApplePaySetup,
                child: const Text('Open apple pay setup')),
          )
        ],
      );
}
