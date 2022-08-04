import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Paytm Gateway Flutter & Php Template',
        theme: ThemeData(primarySwatch: Colors.amber),
        home: const PaytmIntegration(),
      );
}

class PaytmIntegration extends StatefulWidget {
  const PaytmIntegration({super.key});

  @override
  State<PaytmIntegration> createState() => _PaytmIntegrationState();
}

class _PaytmIntegrationState extends State<PaytmIntegration> {
  String result = '';
  final TextEditingController _amountController = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Please Enter Amount to do payment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                maxLength: 5,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(),
                    border: OutlineInputBorder()),
                autofocus: true,
                validator: (String? val) {
                  if (val == null || val.isEmpty) {
                    return 'Please Enter valid Amount';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  child: const Text('PAYTM'),
                  onPressed: () {
                    initiateTransaction().then(
                      (Map<String, dynamic> value) {
                        // final jsonData = jsonDecode(value);
                        if (value['success'] == true) {
                          AllInOneSdk.startTransaction(
                                  value['mid'].toString(),
                                  value['orderId'].toString(),
                                  value['amount'].toString(),
                                  value['txnToken'].toString(),
                                  value['callbackUrl'].toString(),
                                  value['isStaging'] == true,
                                  true)
                              .then((Map? paymentResponse) {
                            result = paymentResponse.toString();
                          }).catchError((Object onError) {
                            if (onError is PlatformException) {
                              setState(() {
                                result =
                                    '${onError.message!} \n ${onError.details!}';
                              });
                            } else {
                              setState(() {
                                result = onError.toString();
                              });
                            }
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(value['message'].toString())));
                        }
                      },
                    );
                  }),
              const SizedBox(height: 12),
              if (result.isNotEmpty)
                Text('Your Response : $result', textAlign: TextAlign.center)
            ],
          ),
        ),
      );

  Future<Map<String, dynamic>> initiateTransaction() async {
    try {
      const String url = 'http://172.29.16.1/paytm_php_flutter/Php/';
      final FormData formData =
          FormData.fromMap(<String, String>{'amount': _amountController.text});
      final Response<dynamic> response = await Dio().post(url, data: formData);
      return jsonDecode(response.data.toString()) as Map<String, dynamic>;
    } on TimeoutException {
      return {
        'success': false,
        'message': 'The connection has timed out, Please try again!'
      };
    } on SocketException catch (e) {
      return <String, dynamic>{'success': false, 'message': e.message};
    } on Exception catch (e) {
      return <String, dynamic>{'success': false, 'message': e.toString()};
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('result', result));
  }
}
