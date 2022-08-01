import 'package:flutter/material.dart';

class ExtraPage extends StatefulWidget {
  const ExtraPage({Key? key}) : super(key: key);

  @override
  State<ExtraPage> createState() => _ExtraPageState();
}

class _ExtraPageState extends State<ExtraPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          FractionallySizedBox(
            heightFactor: 1 / 2,
            widthFactor: 1 / 2,
            child: Container(
              color: Colors.blue,
            ),
          ),
          AspectRatio(
            aspectRatio: 1 / 3,
            child: Container(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
