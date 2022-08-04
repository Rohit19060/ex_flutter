import 'package:flutter/material.dart';

class ExtraPage extends StatefulWidget {
  const ExtraPage({super.key});

  @override
  State<ExtraPage> createState() => _ExtraPageState();
}

class _ExtraPageState extends State<ExtraPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Column(
          children: const [
            FractionallySizedBox(
              heightFactor: 1 / 2,
              widthFactor: 1 / 2,
              child: ColoredBox(
                color: Colors.blue,
              ),
            ),
            AspectRatio(
              aspectRatio: 1 / 3,
              child: ColoredBox(
                color: Colors.red,
              ),
            ),
          ],
        ),
      );
}
