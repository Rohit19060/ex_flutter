import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'State Management',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          useMaterial3: true,
          fontFamily: 'Lato',
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            },
          ),
        ),
        home: FutureBuilder(
          future: Future.wait([
            Future.delayed(const Duration(seconds: 3)),
          ]),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const ColoredBox(color: Colors.red)
                  : const ColoredBox(color: Colors.blue),
        ),
      );
}

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({required super.builder, super.settings});

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == '/') {
      return child;
    }
    return FadeTransition(opacity: animation, child: child);
  }
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (route.settings.name == '/') {
      return child;
    }
    return Opacity(opacity: animation.value, child: child);
  }
}
