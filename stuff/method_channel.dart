import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MethodChannelTest extends StatefulWidget {
  const MethodChannelTest({super.key});

  @override
  State<StatefulWidget> createState() => _MethodChannelTestState();
}

class _MethodChannelTestState extends State<MethodChannelTest> {
  bool _devMode = false;

  final _channel =
      const MethodChannel('com.example.flutter_experiments/dev_mode');

  @override
  void initState() {
    super.initState();
    _channel.invokeMethod<bool>('getDevMode').then((devMode) {
      _devMode = devMode ?? false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('MethodChannel')),
        body: Center(
          child: Text('Debug Mode : $_devMode'),
        ),
      );
}
