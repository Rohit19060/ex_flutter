import 'package:flutter/material.dart';

import 'utilities/marquee.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Experiments',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Flutter Experiments'),
                Material(
                  child: SizedBox(
                    height: 20,
                    width: 400,
                    child: Marquee(text: 'This is bold text to check '),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
