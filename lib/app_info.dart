import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'utilities/constants.dart';

void main() => runApp(MaterialApp(
    title: 'Flutter Experiments',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
    ),
    home: const AppInfo()));

class AppInfo extends StatefulWidget {
  const AppInfo({super.key});

  @override
  State<AppInfo> createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  String appVersion = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      setState(() => _packageInfo = info);
      appVersion = info.version.substring(0, 4) + info.buildNumber;
    });
  }

  Widget _infoTile(String title, String subtitle) => ListTile(
        title: Center(child: Text(title)),
        subtitle: Center(child: Text(subtitle.isEmpty ? 'Not set' : subtitle)),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('App Info'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            _infoTile('App name', _packageInfo.appName),
            _infoTile('Package name', _packageInfo.packageName),
            _infoTile('App version', _packageInfo.version),
            _infoTile('Build number', _packageInfo.buildNumber),
            _infoTile('Build signature', _packageInfo.buildSignature),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text('$appName by King Tech, v$appVersion')),
            const Text('Made with ❤️ in India'),
          ],
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('appVersion', appVersion));
  }
}
