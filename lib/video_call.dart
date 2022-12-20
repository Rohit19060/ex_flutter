import 'package:flutter/material.dart';

import 'utilities/marquee.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Video Call',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // https://docs.agora.io/en/video-calling/get-started/get-started-sdk?platform=flutter
                // Channel: tempChannel
                // Token: 007eJxTYMh/OUHo5O0pCQkJEq4xNzprfWZmyjJpd9buqNa3n3RUM0+BwdLMIsnUNM3YMtEizcTQ0tDS1Mw8KTUxzdgkxTLFKNXwvtbC5IZARob75+wYGKEQxOdmKEnNLXDOSMzLS81hYAAAxoYhHQ==
                // AppID: 968b55f39a8f41919567beaf34d9d2e1
                const Text('Flutter Experiments'),
                Material(
                  child: SizedBox(
                    height: 20,
                    width: 400,
                    child: Marquee(text: 'This is bold text to check '),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
