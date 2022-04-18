import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpiLink extends StatelessWidget {
  const UpiLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          launch(
              "upi://pay?pa=kingrohitjain19060@okaxis&pn=Rohit Jain&cu=INR&am=100&tn=Transaction Note");
        },
        child: const Text("UPI Pay"),
      )),
    );
  }
}

//String upi_url = 'upi://pay?pa=kingrohitjain19060@okaxis&pn=Payee Name&cu=INR&am=100&tn=Transaction Note';
// pa : Payee address, usually found in GooglePay app profile page
// pn : Payee name
// tn : Txn note, basically your message for the payee
// cu : Currency
// am : amount