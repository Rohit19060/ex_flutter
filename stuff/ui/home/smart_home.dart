import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final List<DeviceInfo> mySmartDevices = [
  DeviceInfo(
      name: 'Smart Light',
      iconPath: 'assets/icons/light-bulb.png',
      powerStatus: true),
  DeviceInfo(name: 'Smart AC', iconPath: 'assets/icons/air-conditioner.png'),
  DeviceInfo(name: 'Smart TV', iconPath: 'assets/icons/smart-tv.png'),
  DeviceInfo(name: 'Smart Fan', iconPath: 'assets/icons/fan.png'),
];

class DeviceInfo {
  DeviceInfo(
      {required this.name, required this.iconPath, this.powerStatus = false});
  final String name, iconPath;
  bool powerStatus;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/icons/menu.png',
                      height: 45,
                      color: Colors.grey[800],
                    ),
                    Icon(
                      Icons.person,
                      size: 45,
                      color: Colors.grey[800],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Home,',
                      style:
                          TextStyle(fontSize: 20, color: Colors.grey.shade800),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 204, 204, 204),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  'Smart Devices',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  itemCount: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 1.3,
                  ),
                  itemBuilder: (context, index) => SmartDeviceBox(
                      smartDeviceName: mySmartDevices[index].name,
                      iconPath: mySmartDevices[index].iconPath,
                      powerOn: mySmartDevices[index].powerStatus,
                      onChanged: (value) => setState(
                          () => mySmartDevices[index].powerStatus = value)),
                ),
              )
            ],
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('verticalPadding', verticalPadding));
    properties.add(DoubleProperty('horizontalPadding', horizontalPadding));
  }
}

class SmartDeviceBox extends StatelessWidget {
  const SmartDeviceBox({
    super.key,
    required this.smartDeviceName,
    required this.iconPath,
    required this.powerOn,
    required this.onChanged,
  });
  final String smartDeviceName;
  final String iconPath;
  final bool powerOn;
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: powerOn
                ? Colors.grey[900]
                : const Color.fromARGB(44, 164, 167, 189),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  iconPath,
                  height: 65,
                  color: powerOn ? Colors.white : Colors.grey.shade700,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          smartDeviceName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: powerOn ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Transform.rotate(
                      angle: pi / 2,
                      child: CupertinoSwitch(
                        value: powerOn,
                        onChanged: onChanged,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // ignore: avoid_positional_boolean_parameters
    properties.add(ObjectFlagProperty<void Function(bool p1)?>.has(
        'onChanged', onChanged));
    properties.add(DiagnosticsProperty<bool>('powerOn', powerOn));
    properties.add(StringProperty('iconPath', iconPath));
    properties.add(StringProperty('smartDeviceName', smartDeviceName));
  }
}
