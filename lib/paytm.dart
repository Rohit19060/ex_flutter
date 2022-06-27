import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paytm Gateway Flutter & Php Template',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const PaytmIntegration(),
    );
  }
}

class PaytmIntegration extends StatefulWidget {
  const PaytmIntegration({Key? key}) : super(key: key);

  @override
  _PaytmIntegrationState createState() => _PaytmIntegrationState();
}

class _PaytmIntegrationState extends State<PaytmIntegration> {
  String result = "";
  final TextEditingController _amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Please Enter Amount to do payment",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              maxLength: 5,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(),
                  border: OutlineInputBorder()),
              autofocus: true,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Please Enter valid Amount";
                }
                return null;
              },
            ),
            ElevatedButton(
                child: const Text("PAYTM"),
                onPressed: () {
                  initiateTransaction().then(
                    (value) {
                      final jsonData = jsonDecode(value);
                      if (jsonData["success"]) {
                        AllInOneSdk.startTransaction(
                                jsonData["mid"],
                                jsonData["orderId"],
                                jsonData["amount"],
                                jsonData["txnToken"],
                                jsonData["callbackUrl"],
                                jsonData["isStaging"],
                                true)
                            .then((paymentResponse) {
                          result = paymentResponse.toString();
                        }).catchError((onError) {
                          if (onError is PlatformException) {
                            setState(() {
                              result =
                                  "${onError.message!} \n ${onError.details!}";
                            });
                          } else {
                            setState(() {
                              result = onError.toString();
                            });
                          }
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(jsonData["message"])));
                      }
                    },
                  );
                }),
            const SizedBox(
              height: 12,
            ),
            if (result.isNotEmpty)
              Text(
                "Your Response : $result",
                textAlign: TextAlign.center,
              )
          ],
        ),
      ),
    );
  }

  Future initiateTransaction() async {
    try {
      var url = "http://172.29.16.1/paytm_php_flutter/Php/";
      FormData formData = FormData.fromMap({"amount": _amountController.text});
      var response = await Dio().post(url, data: formData);
      return response.data;
    } on TimeoutException {
      return {
        "success": false,
        "message": 'The connection has timed out, Please try again!'
      };
    } on SocketException {
      return {
        "success": false,
        "message": "Internet Issue! No Internet connection 😑"
      };
    } catch (e) {
      return {"success": false, "message": "Connection Problem"};
    }
  }
}
