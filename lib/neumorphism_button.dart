import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Neumorphism Button',
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
  bool isPressed = false;
  Color backgroundColor = const Color(0xFFE7ECEF);
  Offset distance = const Offset(12, 12);
  double blur = 30;
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          // child: Listener(
          //   onPointerMove: (details) {
          //     print(details);
          //     print('on Pointer Move');
          //   },
          //   onPointerHover: (event) {
          //     print(event);
          //     print('On Pointer Hover');
          //   },
          //   onPointerUp: (event) {
          //     print(event);
          //     print('On Pointer Hover');
          //   },

          //   onPointerSignal: (event) {
          //     print(event);
          //     print('On Pointer Hover');
          //   },
          child: GestureDetector(
            onTap: () => debugPrint('hi'),
            onTapUp: (_) => setState(() => isPressed = false),
            onTapDown: (_) => setState(() => isPressed = true),
            onVerticalDragCancel: () => setState(() => isPressed = false),
            onSecondaryTap: () => debugPrint('Hi Secondary Tap'),
            onHorizontalDragCancel: () => setState(() => isPressed = false),
            onPanUpdate: (details) {},
            onPanStart: (details) {},
            onVerticalDragStart: (_) => setState(() => isPressed = true),
            onHorizontalDragStart: (_) => setState(() => isPressed = true),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: backgroundColor,
                  boxShadow: isPressed
                      ? []
                      : [
                          BoxShadow(
                            blurRadius: blur,
                            offset: -distance,
                            color: const Color.fromARGB(59, 55, 165, 255),
                          ),
                          BoxShadow(
                            blurRadius: blur,
                            offset: distance,
                            color: const Color.fromARGB(59, 55, 165, 255),
                          )
                        ]),
              child: const SizedBox(width: 200, height: 200),
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('blur', blur));
    properties.add(DiagnosticsProperty<Offset>('distance', distance));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DiagnosticsProperty<bool>('isPressed', isPressed));
  }
}
