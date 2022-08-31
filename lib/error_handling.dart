import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) {
      exit(1);
    }
  };
  PlatformDispatcher.instance.onError = (error, stack) => true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        builder: (context, widget) {
          Widget error = const Text('...rendering error...');
          if (widget is Scaffold || widget is Navigator) {
            error = Scaffold(body: Center(child: error));
          }
          ErrorWidget.builder = (errorDetails) => error;
          if (widget != null) {
            return widget;
          }
          throw Error();
        },
      );
}
