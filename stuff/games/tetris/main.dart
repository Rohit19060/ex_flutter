import 'package:flutter/material.dart';

import 'board.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Tetris',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const GameBoard(),
      );
}
