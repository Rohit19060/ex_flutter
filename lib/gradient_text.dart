import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Experiments',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const GradientText(),
      );
}

class GradientText extends StatelessWidget {
  const GradientText({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(colors: [
              Colors.amber,
              Colors.green,
              Colors.red,
            ]).createShader(bounds),
            child: const Text(
              'Hello Flutter World!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
}
