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
      debugPrint('FlutterErrorDetails.informationCollector');
      return <DiagnosticsNode>[];
    },
    stackFilter: (stack) => stack,
  ));
  FlutterError.presentError = (details) async {
    debugPrint('FlutterError: ${details.exception}');
    debugPrint('FlutterError: ${details.context}');
    debugPrint('FlutterError: ${details.informationCollector}');
    debugPrint('FlutterError: ${details.library}');
    debugPrint('FlutterError: ${details.stack}');
    debugPrint('FlutterError: ${details.stackFilter}');
    debugPrint('FlutterError: ${details.silent}');
  };
  FlutterError.onError = (details) {
    debugPrint('FlutterError: ${details.exception}');
    FlutterError.presentError(details);
    if (kReleaseMode) {
      exit(1);
    }
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('PlatformDispatcher: $error');
    debugPrint('PlatformDispatcher: $stack');
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
