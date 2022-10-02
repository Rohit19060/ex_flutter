import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Glass Morphism',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
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
  bool _isBlur = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Image.network('https://tinyurl.com/2p8zr2ze',
                fit: BoxFit.cover, height: double.infinity),
            Center(
              child: GestureDetector(
                onTap: () => setState(() => _isBlur = !_isBlur),
                child: GlassMorphic(
                  blur: _isBlur ? 20 : 0,
                  opacity: 0.2,
                  child: const SizedBox(height: 210, width: 320),
                ),
              ),
            ),
          ],
        ),
      );
}

class GlassMorphic extends StatelessWidget {
  const GlassMorphic({
    super.key,
    required this.blur,
    required this.opacity,
    required this.child,
  });
  final double blur;
  final double opacity;
  final Widget child;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(opacity),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border:
                  Border.all(width: 1.5, color: Colors.white.withOpacity(0.2)),
            ),
            child: child,
          ),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('opacity', opacity));
    properties.add(DoubleProperty('blur', blur));
  }
}
