import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import 'firebase_phone_auth.dart';

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
    final blue1 = await FlutterBluePlus.isOn;
    if (blue1) {
      if (await requestPermission(Permission.bluetoothScan) &&
          await requestPermission(Permission.bluetoothConnect) &&
          await requestPermission(Permission.bluetooth)) {
        final devices = await FlutterBluePlus.connectedDevices;
        final devicesPaired = await FlutterBluePlus.bondedDevices;
      }
    } else {
      showToast('Please Turn On Bluetooth for Printing');
    }
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
