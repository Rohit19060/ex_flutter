
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Neomorphism Button",
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
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    const backgroundCOlor = Color(0xFFE7ECEF);
    Offset distance = const Offset(12, 12);
    double blur = 30;
    return Scaffold(
      backgroundColor: backgroundCOlor,
      body: Center(
        child: Listener(
          onPointerUp: (_) => setState(() => isPressed = false),
          onPointerDown: (_) => setState(() => isPressed = true),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: backgroundCOlor,
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
  }
}
