import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Connection Check',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const ConnectionsCheck(),
      );
}

class ConnectionsCheck extends StatefulWidget {
  const ConnectionsCheck({super.key});

  @override
  State<ConnectionsCheck> createState() => _ConnectionsCheckState();
}

class _ConnectionsCheckState extends State<ConnectionsCheck> {
  bool isOnline = true;
  String hostIp = '';
  final Connectivity _connectivity = Connectivity();
  final TextEditingController _webAddressController = TextEditingController();
  late StreamSubscription<ConnectivityResult> _connectivityStream;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivityStream = _connectivity.onConnectivityChanged.listen((result) {
      setState(() => isOnline = result != ConnectivityResult.none);
    });
  }

  Future<void> initConnectivity() async {
    try {
      await _connectivity.checkConnectivity().then((value) =>
          setState(() => isOnline = value != ConnectivityResult.none));
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
  }

  @override
  void dispose() {
    _connectivityStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: _webAddressController,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.black),
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Web Address',
                    counterText: '',
                    border: const OutlineInputBorder(),
                    hintText: 'Enter a Web Address',
                    suffix: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        splashRadius: 18,
                        constraints:
                            const BoxConstraints(maxHeight: 18, maxWidth: 18),
                        icon: const Icon(Icons.search, size: 18),
                        onPressed: () async {
                          try {
                            final result = await InternetAddress.lookup(
                                _webAddressController.text);
                            setState(() => hostIp = result.first.address);
                          } on SocketException catch (e) {
                            setState(() => hostIp = e.message);
                          } on Exception catch (e) {
                            setState(() => hostIp = e.toString());
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              if (hostIp.isNotEmpty) Text('Host IP: $hostIp'),
              Text(
                'IsOnline: $isOnline',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('hostIp', hostIp));
    properties.add(DiagnosticsProperty<bool>('isOnline', isOnline));
  }
}
