import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
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
  String x = "";

  Map<String, String> get headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        "Access-Control-Allow-Methods": "GET,HEAD,OPTIONS,POST,PUT",
        "Access-Control-Allow-Headers":
            "Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers"
      };

  getImage() async {
    var request = http.get(
      Uri.parse(
          'https://firebasestorage.googleapis.com/v0/b/vatsalaya-parivar-foundation.appspot.com/o/Doc%20Images%2Fimage_picker263424257541013687.jpg?alt=media&token=b3c274d5-d35e-4933-b853-7a1f6a19b3a4'),
      headers: headers,
    );
    var response = await request;
    setState(() {
      x = response.bodyBytes.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Center(
            child: Text("Flutter Experiments"),
          ),
          ElevatedButton(
            onPressed: getImage,
            child: Text(x),
          ),
        ],
      ),
    );
  }
}
