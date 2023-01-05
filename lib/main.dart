import 'package:flutter/material.dart';

import 'shimmer_effect.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Experiments',
        theme: ThemeData(useMaterial3: true),
        home: const ShimmerHome(),
      );
}
