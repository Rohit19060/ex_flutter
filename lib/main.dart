import 'package:flutter/material.dart';

import 'animated_neumorphism.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Experiments",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AnimatedNeumorphism(),
    );
  }
}
