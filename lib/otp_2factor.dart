import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pinput/pinput.dart';

void main() async {
  await dotenv.load(fileName: 'lib/.env');
  runApp(const MaterialApp(home: HomePage()));
}

Future<Map<String, String>> sendRequest(String url) async {
  try {
    final response = await get(Uri.parse(url),
        headers: <String, String>{'Accept': 'application/json'});
    final x = json.decode(response.body) as Map<String, String>;
    return <String, String>{
      'status': x['status'].toString(),
      'message': x['message'].toString()
    };
  } on SocketException catch (e) {
    return <String, String>{
      'Status': 'Internet Issue',
      'Details': e.message,
    };
  } on Exception catch (e) {
    return <String, String>{
      'Status': 'Server Problem',
      'Details': e.toString()
    };
  }
}

Future<Map<String, String>> sendOtp({required String mob}) => sendRequest(
    "https://2factor.in/API/V1/${dotenv.env['otpkey']}/SMS/$mob/AUTOGEN");

Future<Map<String, String>> validateOTP(
        {required String sessionId, required String otp}) =>
    sendRequest(
        "https://2factor.in/API/V1/${dotenv.env['otpkey']}/SMS/VERIFY/$sessionId/$otp");

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _mobController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpSent = false;
  String _sessionId = '';
  bool _buttonActive = false;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _mobController.dispose();
    _otpController.dispose();
  }

  void _sendOtp() {
    setState(() => _isLoading = true);
    sendOtp(mob: _mobController.text).then((value) {
      if (value['Status'] == 'Success') {
        Fluttertoast.showToast(msg: 'Otp Sent Successfully');
        _isOtpSent = true;
        _sessionId = value['Details'].toString();
        _buttonActive = false;
      } else {
        Fluttertoast.showToast(msg: value['Details'] ?? 'Server Issue');
      }
      setState(() => _isLoading = false);
    });
  }

  void _validateOTP() {
    setState(() => _isLoading = true);
    validateOTP(otp: _otpController.text, sessionId: _sessionId).then((value) {
      if (value['Status'] == 'Success') {
        Fluttertoast.showToast(msg: 'Mobile Number Verified');
        _isOtpSent = false;
        _sessionId = '';
        _mobController.text = '';
        _otpController.text = '';
        _buttonActive = false;
      } else {
        Fluttertoast.showToast(msg: value['Details'] ?? 'Invalid OTP');
      }
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            '2Factor Authentication',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_mobController.text.length >= 10 && _isOtpSent)
                Container(
                  margin: const EdgeInsets.all(40.0),
                  child: Text(
                    '+91 ${_mobController.text}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              if (_isOtpSent)
                Pinput(
                  autofocus: _isOtpSent,
                  controller: _otpController,
                  androidSmsAutofillMethod:
                      AndroidSmsAutofillMethod.smsUserConsentApi,
                  onClipboardFound: (value) {
                    _otpController.text = value;
                  },
                  length: 6,
                  onChanged: (value) {
                    setState(() {
                      if (value.length >= 6) {
                        _buttonActive = true;
                      } else {
                        _buttonActive = false;
                      }
                    });
                  },
                )
              else
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Enter Mobile Number',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(3),
                      ),
                      borderSide: BorderSide(width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(3),
                      ),
                      borderSide: BorderSide(width: 2.0),
                    ),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                    prefix: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text('+91'),
                    ),
                  ),
                  style: const TextStyle(fontSize: 24),
                  autofocus: !_isOtpSent,
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.send,
                  keyboardType: TextInputType.number,
                  controller: _mobController,
                  onChanged: (value) {
                    setState(() {
                      if (value.length >= 10) {
                        _buttonActive = true;
                      } else {
                        _buttonActive = false;
                      }
                    });
                  },
                  maxLength: 10,
                  onFieldSubmitted: (_) {
                    _sendOtp();
                  },
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    _isLoading
                        ? RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))
                        : RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0)),
                  ),
                  overlayColor:
                      MaterialStateProperty.all(Colors.black.withOpacity(0.2)),
                  elevation: _buttonActive
                      ? MaterialStateProperty.all(8)
                      : MaterialStateProperty.all(0),
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(
                    _isLoading
                        ? const EdgeInsets.all(10)
                        : const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                  ),
                ),
                onPressed: _buttonActive
                    ? _isOtpSent
                        ? _validateOTP
                        : _sendOtp
                    : null,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        _isOtpSent ? 'Validate Otp' : 'Send Otp',
                        style: const TextStyle(fontSize: 26),
                      ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      );
}
