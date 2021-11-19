import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Experiments',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _notify() async {
    try {
      var response = await Dio().post("https://fcm.googleapis.com/fcm/send",
          data: {
            "to": dotenv.env['token'],
            "notification": {
              "title": "Notification Title",
              "body": "Notification Body"
            },
          },
          options: Options(
              headers: {"Authorization": "Key=${dotenv.env['FCMkey']}"}));
      debugPrint(response.data.toString());
    } on TimeoutException {
      debugPrint('The connection has timed out, Please try again!');
    } on SocketException {
      debugPrint("Internet Issue! No Internet connection 😑");
    } catch (e) {
      debugPrint("Connection Problem $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Center(
          child: Text("Flutter Experiments"),
        ),
        floatingActionButton: FloatingActionButton(
          foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
          onPressed: _notify,
          child: const FlutterLogo(
            style: FlutterLogoStyle.markOnly,
          ),
        ));
  }
}
