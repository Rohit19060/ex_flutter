import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'env.dart';
import 'screens/screens.dart';
import 'widgets/dismiss_focus_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => DismissFocusOverlay(
        child: MaterialApp(
          theme: exampleAppTheme,
          home: const HomePage(),
        ),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Stripe Examples'),
        ),
        body: ListView(children: [
          ...ListTile.divideTiles(
            context: context,
            tiles: [for (final example in Example.screens) example],
          ),
        ]),
      );
}

final exampleAppTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Color(0xff6058F7),
    secondary: Color(0xff6058F7),
  ),
  primaryColor: Colors.white,
  appBarTheme: const AppBarTheme(elevation: 1),
);
