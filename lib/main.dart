import 'package:flutter/material.dart';

import 'small_widget.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    const value = 10;
    return MaterialApp(
      title: 'Flutter Experiments',
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: size.width * 0.5,
                child: const RoundedProgressBar(
                  value: value,
                  duration: 800,
                ),
              ),
              const Text(
                'Value: $value',
                style: TextStyle(fontSize: 24),
              )
            ],
          ),
        ),
      ),
    );
  }
}
