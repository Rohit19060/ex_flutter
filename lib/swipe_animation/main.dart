import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'cards.dart';
import 'matches.dart';
import 'profiles.dart';

void main() => runApp(const MyApp());
final MatchEngine matchEngine = MatchEngine(
    matches:
        demoProfiles.map((profile) => DateMatch(profile: profile)).toList());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Swiping Animation',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AppBar _buildAppBar() => AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              icon: const Icon(Icons.person, color: Colors.grey, size: 40),
              onPressed: () {}),
          centerTitle: true,
          title: const FlutterLogo(size: 30),
          actions: [
            IconButton(
                icon: const Icon(Icons.person, color: Colors.grey, size: 40),
                onPressed: () {})
          ]);

  Widget _buildBottomBar() => BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundIconButton.small(
                icon: Icons.refresh,
                iconColor: Colors.orange,
                onPressed: () {},
              ),
              RoundIconButton.large(
                icon: Icons.clear,
                iconColor: Colors.red,
                onPressed: () {
                  matchEngine.currentMatch.nope();
                },
              ),
              RoundIconButton.small(
                icon: Icons.star,
                iconColor: Colors.blue,
                onPressed: () {
                  matchEngine.currentMatch.superLike();
                },
              ),
              RoundIconButton.large(
                icon: Icons.favorite,
                iconColor: Colors.green,
                onPressed: () {
                  matchEngine.currentMatch.like();
                },
              ),
              RoundIconButton.small(
                icon: Icons.lock,
                iconColor: Colors.purple,
                onPressed: () {},
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppBar(),
        body: CardStack(matchEngine: matchEngine),
        bottomNavigationBar: _buildBottomBar(),
      );
}

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.size,
    required this.iconColor,
    required this.onPressed,
  });
  const RoundIconButton.small({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.onPressed,
  }) : size = 50;

  const RoundIconButton.large({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.onPressed,
  }) : size = 60;
  final IconData icon;
  final Color iconColor;
  final double size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [BoxShadow(color: Color(0x11000000), blurRadius: 10)]),
        child: RawMaterialButton(
            shape: const CircleBorder(),
            elevation: 0,
            onPressed: onPressed,
            child: Icon(icon, color: iconColor)),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
    properties.add(DoubleProperty('size', size));
    properties.add(ColorProperty('iconColor', iconColor));
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
  }
}
