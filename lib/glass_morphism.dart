import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Experiments',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isBlur = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.network('https://tinyurl.com/2p8zr2ze',
              fit: BoxFit.cover, height: double.infinity),
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isBlur = !_isBlur;
                });
              },
              child: GlassMorphic(
                  blur: _isBlur ? 20 : 0,
                  opacity: 0.2,
                  child: const SizedBox(height: 210, width: 320)),
            ),
          ),
        ],
      ),
    );
  }
}

class GlassMorphic extends StatelessWidget {
  final double blur;
  final double opacity;
  final Widget child;
  const GlassMorphic(
      {Key? key,
      required this.blur,
      required this.opacity,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(opacity),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border:
                  Border.all(width: 1.5, color: Colors.white.withOpacity(0.2)),
            ),
            child: child),
      ),
    );
  }
}
