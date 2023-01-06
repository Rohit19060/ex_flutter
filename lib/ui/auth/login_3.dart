import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Container(
            width: 200.0,
            height: 200.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/reflectly.jpg',
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      upperBound: 0.1,
    )..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    const color = Colors.white;
    const delayedAmount = 500;
    _scale = 1 - _controller.value;
    return Scaffold(
      backgroundColor: const Color(0xFF8185E2),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DelayedAnimation(
                delay: delayedAmount + 1000,
                child: AvatarGlow(
                  endRadius: 90.0,
                  glowColor: Colors.white24,
                  repeatPauseDuration: const Duration(seconds: 2),
                  startDelay: const Duration(seconds: 1),
                  child: Material(
                    elevation: 8.0,
                    shape: const CircleBorder(),
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: ClipOval(
                        child: Image.asset('assets/images/reflectly.jpg'),
                      ),
                    ),
                  ),
                ),
              ),
              const DelayedAnimation(
                delay: delayedAmount + 2000,
                child: Text(
                  'Hi there,',
                  style: TextStyle(
                    color: color,
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Avenir',
                  ),
                ),
              ),
              const DelayedAnimation(
                delay: delayedAmount + 2500,
                child: Text(
                  "I'm Reflectly",
                  style: TextStyle(
                    color: color,
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Avenir',
                  ),
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              const DelayedAnimation(
                delay: delayedAmount + 3000,
                child: Text(
                  'Your new personal ',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Avenir',
                  ),
                ),
              ),
              const DelayedAnimation(
                delay: delayedAmount + 3000,
                child: Text(
                  'self-care companion',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Avenir',
                  ),
                ),
              ),
              const SizedBox(
                height: 120.0,
              ),
              DelayedAnimation(
                delay: delayedAmount + 4000,
                child: GestureDetector(
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  child: Transform.scale(
                    scale: _scale,
                    child: _animatedButtonUI,
                  ),
                ),
              ),
              const SizedBox(
                height: 80.0,
              ),
              DelayedAnimation(
                delay: delayedAmount + 5000,
                child: Text(
                  'I Already Have An Account'.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Avenir',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _animatedButtonUI => Container(
        height: 70,
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            'Hi, Reflectly!'.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF8185E2),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Avenir',
            ),
          ),
        ),
      );

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }
}

class DelayedAnimation extends StatefulWidget {
  const DelayedAnimation({super.key, required this.delay, required this.child});
  final Widget child;
  final int delay;
  @override
  State<DelayedAnimation> createState() => _DelayedAnimationState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('delay', delay));
  }
}

class _DelayedAnimationState extends State<DelayedAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animationOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    final curve = CurvedAnimation(
      curve: Curves.decelerate,
      parent: _controller,
    );

    _animationOffset =
        Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero)
            .animate(curve);

    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _controller,
        child: SlideTransition(
          position: _animationOffset,
          child: widget.child,
        ),
      );
}
