import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform()
        .then((info) => setState(() => _packageInfo = info));
  }

  Widget _infoTile(String title, String subtitle) => ListTile(
        title: Text(title),
        subtitle: Text(subtitle.isEmpty ? 'Not set' : subtitle),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('App Info')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _infoTile('App name', _packageInfo.appName),
            _infoTile('Package name', _packageInfo.packageName),
            _infoTile('App version', _packageInfo.version),
            _infoTile('Build number', _packageInfo.buildNumber),
            _infoTile('Build signature', _packageInfo.buildSignature),
          ],
        ),
      );
}
