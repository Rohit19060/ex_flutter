import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Experiments',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AnimatedNeumorphism(),
    );
  }
}

class AnimatedNeumorphism extends StatefulWidget {
  const AnimatedNeumorphism({Key? key}) : super(key: key);
  @override
  State<AnimatedNeumorphism> createState() => _AnimatedNeumorphismState();
}

class _AnimatedNeumorphismState extends State<AnimatedNeumorphism>
    with TickerProviderStateMixin {
  double turns = 0.0;
  bool isClicked = false;
  late AnimationController _controller;
  Color customBlackColor = const Color.fromARGB(255, 53, 53, 53);
  Color customWhiteColor = const Color.fromARGB(255, 237, 237, 237);
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customWhiteColor,
      body: Center(
        child: AnimatedRotation(
          curve: Curves.easeOutExpo,
          turns: turns,
          duration: const Duration(seconds: 1),
          child: GestureDetector(
            onTap: () {
              if (isClicked) {
                setState(() => turns -= 1 / 4);
                _controller.reverse();
              } else {
                setState(() => turns += 1 / 4);
                _controller.forward();
              }
              isClicked = !isClicked;
            },
            child: AnimatedContainer(
              curve: Curves.easeOutExpo,
              duration: const Duration(seconds: 1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: customWhiteColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 30.0,
                    offset: isClicked
                        ? const Offset(20, -20)
                        : const Offset(20, 20),
                    color: Colors.grey,
                  ),
                  BoxShadow(
                    blurRadius: 30.0,
                    offset: isClicked
                        ? const Offset(-20, 20)
                        : const Offset(-20, -20),
                    color: Colors.white,
                  )
                ],
              ),
              child: SizedBox(
                height: 150,
                width: 150,
                child: Center(
                  child: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: _controller,
                    size: 100,
                    color: customBlackColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
