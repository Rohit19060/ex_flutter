import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../utils.dart';
import '../../widgets/example_scaffold.dart';
import '../../widgets/loading_button.dart';
import '../../widgets/response_card.dart';

class LegacyTokenBankScreen extends StatefulWidget {
  @override
  _LegacyTokenBankScreenState createState() => _LegacyTokenBankScreenState();
}

class _LegacyTokenBankScreenState extends State<LegacyTokenBankScreen> {
  late TextEditingController _controller;
  TokenData? tokenData;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExampleScaffold(
        title: 'Create token for bank',
        tags: const ['Legacy'],
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Accountnumber',
            ),
          ),
          const SizedBox(height: 20),
          LoadingButton(
            onPressed: _handleCreateTokenPress,
            text: 'Create token',
          ),
          const SizedBox(height: 20),
          if (tokenData != null)
            ResponseCard(
              response: tokenData!.toJson().toPrettyString(),
            )
        ],
      );

  Future<void> _handleCreateTokenPress() async {
    try {
      // 1. Gather customer billing information (ex. email)
      final params = BankAccountTokenParams(
        currency: 'EUR',
        country: 'DE',
        accountNumber: _controller.text,
        accountHolderName: 'Dash Flutter',
        accountHolderType: BankAccountHolderType.Individual,
      ); // mocked data for tests

      // 2. Create payment method
      final tokenData = await Stripe.instance
          .createToken(CreateTokenParams.bankAccount(params: params));
      setState(() {
        this.tokenData = tokenData;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Success: The token was created successfully!')));
      return;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
      rethrow;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TokenData?>('tokenData', tokenData));
  }
}
