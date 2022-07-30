import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Experiments',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Scaffold(
        body: Center(
          child: Text('Flutter Experiments'),
        ),
      ),
    );
  }
}
