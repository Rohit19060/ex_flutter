import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  FlutterError.reportError(FlutterErrorDetails(
    exception: Exception('FlutterErrorDetails.exception'),
    stack: StackTrace.current,
    library: 'FlutterErrorDetails.library',
    context: ErrorDescription('FlutterErrorDetails.context'),
    informationCollector: () {
      print('FlutterErrorDetails.informationCollector');
      return <DiagnosticsNode>[];
    },
    stackFilter: (stack) => stack,
  ));
  FlutterError.presentError = (details) async {
    print('FlutterError: ${details.exception}');
    print('FlutterError: ${details.context}');
    print('FlutterError: ${details.informationCollector}');
    print('FlutterError: ${details.library}');
    print('FlutterError: ${details.stack}');
    print('FlutterError: ${details.stackFilter}');
    print('FlutterError: ${details.silent}');
  };
  FlutterError.onError = (details) {
    print('FlutterError: ${details.exception}');
    FlutterError.presentError(details);
    if (kReleaseMode) {
      exit(1);
    }
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    print('PlatformDispatcher: $error');
    print('PlatformDispatcher: $stack');
    return false;
  };
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
