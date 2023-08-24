import 'package:flutter/material.dart';

import 'material_you_navigation.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Flutter Experiments',
      theme:
          ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSwatch()),
      home: const MaterialYouNavigation());
}
