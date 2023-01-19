import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../utils.dart';
import '../../widgets/example_scaffold.dart';
import '../../widgets/loading_button.dart';
import '../../widgets/response_card.dart';

class LegacyTokenCardScreen extends StatefulWidget {
  @override
  _LegacyTokenCardScreenState createState() => _LegacyTokenCardScreenState();
}

class _LegacyTokenCardScreenState extends State<LegacyTokenCardScreen> {
  CardFieldInputDetails? _card;

  TokenData? tokenData;

  @override
  Widget build(BuildContext context) => ExampleScaffold(
        title: 'Create token for card',
        tags: const ['Legacy'],
        padding: const EdgeInsets.all(16),
        children: [
          CardField(
            autofocus: true,
            onCardChanged: (card) {
              setState(() {
                _card = card;
              });
            },
          ),
          const SizedBox(height: 20),
          LoadingButton(
            onPressed: _card?.complete == true ? _handleCreateTokenPress : null,
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
    if (_card == null) {
      return;
    }

    try {
      // 1. Gather customer billing information (ex. email)
      const address = Address(
        city: 'Houston',
        country: 'US',
        line1: '1459  Circle Drive',
        line2: '',
        state: 'Texas',
        postalCode: '77063',
      ); // mocked data for tests

      // 2. Create payment method
      final tokenData = await Stripe.instance.createToken(
          CreateTokenParams.card(
              params: CardTokenParams(address: address, currency: 'USD')));
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
