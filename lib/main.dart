import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Experiments",
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
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
         launch("upi://pay?pa=kingrohitjain19060@okaxis&pn=Rohit Jain&tn=Paying for Fun&cu=INR");
          },
          child: const Text("GPay"),
        ),
      ),
    );
  }
}
//String upi_url = 'upi://pay?pa=address@okhdfcbank&pn=Payee Name&tn=Payment Message&cu=INR';
// pa : Payee address, usually found in GooglePay app profile page
// pn : Payee name
// tn : Txn note, basically your message for the payee
// cu : Currency
// am : amount