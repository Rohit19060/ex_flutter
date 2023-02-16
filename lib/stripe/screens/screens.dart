import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../screens/checkout/checkout_screen.dart';
import '../screens/payment_sheet/payment_element/payment_element.dart';
import '../screens/payment_sheet/payment_sheet_screen.dart';
import '../screens/payment_sheet/payment_sheet_screen_custom_flow.dart';
import '../screens/regional_payment_methods/ali_pay_screen.dart';
import '../screens/regional_payment_methods/aubecs_debit.dart';
import '../screens/regional_payment_methods/fpx_screen.dart';
import '../screens/regional_payment_methods/ideal_screen.dart';
import '../screens/regional_payment_methods/klarna_screen.dart';
import '../screens/regional_payment_methods/paypal_screen.dart';
import '../screens/regional_payment_methods/sofort_screen.dart';
import '../screens/regional_payment_methods/us_bank_account.dart';
import '../screens/wallets/apple_pay_screen_plugin.dart';
import '../screens/wallets/google_pay_screen.dart';
import '../screens/wallets/open_apple_pay_setup_screen.dart';
import '../widgets/platform_icons.dart';
import 'card_payments/custom_card_payment_screen.dart';
import 'card_payments/no_webhook_payment_cardform_screen.dart';
import 'card_payments/no_webhook_payment_screen.dart';
import 'card_payments/webhook_payment_screen.dart';
import 'financial_connections.dart/financial_connections_session_screen.dart';
import 'others/cvc_re_collection_screen.dart';
import 'others/legacy_token_bank_screen.dart';
import 'others/legacy_token_card_screen.dart';
import 'others/setup_future_payment_screen.dart';
import 'regional_payment_methods/grab_pay_screen.dart';
import 'themes.dart';

class ExampleSection extends StatelessWidget {
  const ExampleSection({
    super.key,
    required this.title,
    required this.children,
    this.expanded = false,
  });
  final String title;
  final List<Widget> children;
  final bool expanded;

  @override
  Widget build(BuildContext context) => ExpansionTile(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
        initiallyExpanded: expanded,
        childrenPadding: const EdgeInsets.only(left: 20),
        title: Text(title),
        children:
            ListTile.divideTiles(tiles: children, context: context).toList(),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('expanded', expanded));
    properties.add(StringProperty('title', title));
  }
}

class Example extends StatelessWidget {
  const Example({
    super.key,
    required this.title,
    required this.builder,
    this.style,
    this.leading,
    this.platformsSupported = DevicePlatform.values,
  });
  final String title;
  final TextStyle? style;
  final Widget? leading;
  final List<DevicePlatform> platformsSupported;

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: () {
          final route = MaterialPageRoute(builder: builder);
          Navigator.push(context, route);
        },
        title: Text(title, style: style),
        leading: leading,
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          PlatformIcons(supported: platformsSupported),
          const Icon(Icons.chevron_right_rounded),
        ]),
      );

  static List<Example> paymentMethodScreens = [];

  static List<Widget> screens = [
    ExampleSection(
      title: 'Payment Sheet',
      expanded: true,
      children: [
        Example(
          title: 'Single Step',
          builder: (context) => PaymentSheetScreen(),
          platformsSupported: const [
            DevicePlatform.android,
            DevicePlatform.ios
          ],
        ),
        Example(
          title: 'Custom Flow',
          builder: (context) => PaymentSheetScreenWithCustomFlow(),
          platformsSupported: const [
            DevicePlatform.android,
            DevicePlatform.ios
          ],
        ),
        Example(
          title: 'Web Payment Element',
          builder: (c) => PaymentElementExample(),
          platformsSupported: const [
            DevicePlatform.web,
          ],
        ),
      ],
    ),
    ExampleSection(
      title: 'Card Payments',
      children: [
        Example(
          title: 'Simple - Using webhooks',
          style: const TextStyle(fontWeight: FontWeight.w600),
          builder: (c) => WebhookPaymentScreen(),
        ),
        Example(
          title: 'Without webhooks',
          builder: (c) => NoWebhookPaymentScreen(),
        ),
        Example(
          title: 'Card Field themes',
          builder: (c) => ThemeCardExample(),
        ),
        Example(
          title: 'Card Form',
          builder: (c) => NoWebhookPaymentCardFormScreen(),
          platformsSupported: const [
            DevicePlatform.android,
            DevicePlatform.ios
          ],
        ),
        Example(
          title: 'Flutter UI (not PCI compliant)',
          builder: (c) => CustomCardPaymentScreen(),
          platformsSupported: const [
            DevicePlatform.android,
            DevicePlatform.ios
          ],
        ),
      ],
    ),
    ExampleSection(
      title: 'Wallets',
      children: [
        // Example(
        //   title: 'Apple Pay',
        //   leading: Image.asset(
        //     'assets/apple_pay.png',
        //     width: 48,
        //   ),
        //   builder: (c) => ApplePayScreen(),
        //   platformsSupported: const [DevicePlatform.ios],
        // ),
        Example(
          title: 'Apple Pay - Pay Plugin',
          leading: Image.asset(
            'assets/apple_pay.png',
            width: 48,
          ),
          builder: (c) => ApplePayExternalPluginScreen(),
          platformsSupported: const [DevicePlatform.ios],
        ),
        Example(
          title: 'Open Apple Pay setup',
          leading: Image.asset(
            'assets/apple_pay.png',
            width: 48,
          ),
          builder: (c) => const OpenApplePaySetup(),
          platformsSupported: const [DevicePlatform.ios],
        ),
        // Example(
        //   leading: Image.asset(
        //     'assets/google_play.png',
        //     width: 48,
        //   ),
        //   title: 'Google Pay',
        //   builder: (c) => const GooglePayStripeScreen(),
        //   platformsSupported: const [DevicePlatform.android],
        // ),
        Example(
          leading: Image.asset(
            'assets/google_play.png',
            width: 48,
          ),
          title: 'Google Pay - Pay Plugin',
          builder: (c) => GooglePayScreen(),
          platformsSupported: const [DevicePlatform.android],
        ),
      ],
    ),
    ExampleSection(title: 'Regional Payment Methods', children: [
      Example(
        title: 'Ali Pay',
        leading: Image.asset(
          'assets/alipay.png',
          width: 48,
        ),
        builder: (context) => const AliPayScreen(),
        platformsSupported: const [DevicePlatform.android, DevicePlatform.ios],
      ),
      Example(
        title: 'Ideal',
        leading: Image.asset(
          'assets/ideal_pay.png',
          width: 48,
        ),
        builder: (context) => const IdealScreen(),
        platformsSupported: const [DevicePlatform.android, DevicePlatform.ios],
      ),
      Example(
        title: 'Sofort',
        leading: const SizedBox(),
        builder: (context) => const SofortScreen(),
        platformsSupported: const [DevicePlatform.android, DevicePlatform.ios],
      ),
      Example(
        title: 'Aubecs',
        builder: (context) => const AubecsExample(),
      ),
      Example(
        title: 'Fpx',
        leading: Image.asset(
          'assets/fpx.png',
          width: 48,
        ),
        builder: (contex) => const FpxScreen(),
      ),
      Example(
        title: 'Grab pay',
        leading: Image.asset(
          'assets/grab_pay.png',
          width: 48,
        ),
        builder: (contex) => const GrabPayScreen(),
      ),
      Example(
        title: 'Klarna',
        leading: Image.asset(
          'assets/klarna.jpg',
          width: 48,
        ),
        builder: (contex) => const KlarnaScreen(),
      ),
      Example(
        title: 'PayPal',
        leading: Image.asset(
          'assets/paypal.png',
          width: 48,
        ),
        builder: (contex) => const PayPalScreen(),
        platformsSupported: const [DevicePlatform.android, DevicePlatform.ios],
      ),
      Example(
        title: 'Us bank accounts (ACH)',
        builder: (contex) => UsBankAccountScreen(),
      ),
      // TODO: uncomment when we can re-enable wechat pay
      // Example(
      //   title: 'WeChat Pay',
      //   leading: Image.asset(
      //     'assets/wechat_pay.png',
      //     width: 48,
      //   ),
      //   builder: (context) => WeChatPayScreen(),
      // ),
    ]),
    ExampleSection(
      title: 'Financial connections',
      children: [
        Example(
          title: 'Financial connection sessions',
          builder: (_) => const FinancialConnectionsScreen(),
          platformsSupported: const [
            DevicePlatform.android,
            DevicePlatform.ios,
          ],
        ),
      ],
    ),
    ExampleSection(title: 'Others', children: [
      Example(
        title: 'Setup Future Payment',
        builder: (c) => SetupFuturePaymentScreen(),
        platformsSupported: const [DevicePlatform.android, DevicePlatform.ios],
      ),
      Example(
        title: 'Re-collect CVC',
        builder: (c) => CVCReCollectionScreen(),
        platformsSupported: const [DevicePlatform.android, DevicePlatform.ios],
      ),
      Example(
        title: 'Create token for card (legacy)',
        builder: (context) => LegacyTokenCardScreen(),
        platformsSupported: const [DevicePlatform.android, DevicePlatform.ios],
      ),
      Example(
        title: 'Create token for bank (legacy)',
        builder: (context) => LegacyTokenBankScreen(),
        platformsSupported: const [DevicePlatform.android, DevicePlatform.ios],
      ),
    ]),
    Example(
      title: 'Checkout',
      builder: (c) => const CheckoutScreenExample(),
      platformsSupported: const [
        DevicePlatform.android,
        DevicePlatform.ios,
        DevicePlatform.web
      ],
    ),
  ];
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<WidgetBuilder>.has('builder', builder));
    properties.add(IterableProperty<DevicePlatform>(
        'platformsSupported', platformsSupported));
    properties.add(DiagnosticsProperty<TextStyle?>('style', style));
    properties.add(StringProperty('title', title));
  }
}
