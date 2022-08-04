import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Shimmer Effect',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Shimmer.fromColors(
            baseColor: Colors.black,
            highlightColor: Colors.grey,
            child: Center(
              child: Container(
                height: 500,
                width: 500,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
}
