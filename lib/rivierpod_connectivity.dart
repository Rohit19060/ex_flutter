import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final isConnectedState = StateProvider<bool>((ref) => false);

final isConnectedStream = StreamProvider.autoDispose<bool>((ref) async* {
  final connectivity = Connectivity();
  final subscription = connectivity.onConnectivityChanged.listen((event) {
    ref.read(isConnectedState.notifier).state =
        event != ConnectivityResult.none;
    ref.keepAlive();
  });
  await for (final result in connectivity.onConnectivityChanged) {
    yield result != ConnectivityResult.none;
  }
  await subscription.cancel();
});

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    ref.read(isConnectedStream);
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = ref.watch(isConnectedState);
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text(isConnected.toString())),
      ),
    );
  }
}
