import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BlueToothApp extends StatefulWidget {
  const BlueToothApp({super.key});

  @override
  State<BlueToothApp> createState() => _BlueToothAppState();
}

class _BlueToothAppState extends State<BlueToothApp> {
  @override
  void initState() {
    super.initState();
    checkBluetooth();
  }

  Future<void> checkBluetooth() async {
    await FlutterBluePlus.turnOn();
    FlutterBluePlus.adapterState.listen((event) async {
      if (event == BluetoothAdapterState.on) {
        if (await requestPermission(Permission.bluetoothScan) &&
            await requestPermission(Permission.bluetoothConnect) &&
            await requestPermission(Permission.bluetooth)) {
          final devices = await FlutterBluePlus.connectedSystemDevices;
          final devicesPaired = await FlutterBluePlus.bondedDevices;
          debugPrint(devicesPaired.toString());
          debugPrint(devices.toString());
        }
      }
    });
  }

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      final result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Bluetooth Scan'),
        ),
        body: const Column(),
      );
}
