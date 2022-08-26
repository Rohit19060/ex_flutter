import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pinput/pinput.dart';

void main() async {
  await dotenv.load(fileName: 'lib/.env');
  runApp(MaterialApp(
    home: const HomePage(),
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: Colors.blue,
    ),
  ));
}

Future<Map<String, String>> sendRequest(String url) async {
  try {
    final response = await get(Uri.parse(url),
        headers: <String, String>{'Accept': 'application/json'});
    final x = json.decode(response.body) as Map<String, dynamic>;
    return <String, String>{
      'Status': x['Status'].toString(),
      'Details': x['Details'].toString()
    };
  } on SocketException catch (e) {
    return <String, String>{'Status': 'Internet Issue', 'Details': e.message};
  } on Exception catch (e) {
    return <String, String>{
      'Status': 'Server Problem',
      'Details': e.toString()
    };
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _mobController = TextEditingController(),
      _otpController = TextEditingController();
  bool _isOtpSent = false, _buttonActive = false, _isLoading = false;
  String _sessionId = '';

  @override
  void dispose() {
    super.dispose();
    _mobController.dispose();
    _otpController.dispose();
  }

  void showToast(String str) => Fluttertoast.showToast(msg: str);

  Future<void> _sendOtp() async {
    setState(() => _isLoading = true);
    await sendRequest(
            "https://2factor.in/API/V1/${dotenv.env['otpkey']}/SMS/${_mobController.text}/AUTOGEN")
        .then((value) {
      if (value['Status'] == 'Success') {
        showToast('Otp Sent Successfully');
        _isOtpSent = true;
        _sessionId = value['Details'].toString();
        _buttonActive = false;
      } else {
        showToast(value['Details'] ?? 'Server Issue');
      }
    });
    setState(() => _isLoading = false);
  }

  Future<void> _validateOTP() async {
    setState(() => _isLoading = true);
    await sendRequest(
            "https://2factor.in/API/V1/${dotenv.env['otpkey']}/SMS/VERIFY/$_sessionId/${_otpController.text}")
        .then((value) {
      if (value['Status'] == 'Success') {
        showToast('Mobile Number Verified');
        reset();
      } else {
        showToast(value['Details'] ?? 'Invalid OTP');
      }
    });
    setState(() => _isLoading = false);
  }

  void reset() {
    _isOtpSent = false;
    _sessionId = '';
    _mobController.clear();
    _otpController.clear();
    _buttonActive = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            '2Factor Authentication',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Center(
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
                Center(
                  child: Pinput(
                    autofocus: _isOtpSent,
                    controller: _otpController,
                    androidSmsAutofillMethod:
                        AndroidSmsAutofillMethod.smsUserConsentApi,
                    onClipboardFound: (value) {},
                    length: 6,
                    onChanged: (value) =>
                        setState(() => _buttonActive = value.length >= 6),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _mobController,
                    style: const TextStyle(fontSize: 24),
                    autofocus: !_isOtpSent,
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.send,
                    keyboardType: TextInputType.number,
                    onChanged: (value) =>
                        setState(() => _buttonActive = value.length >= 10),
                    maxLength: 10,
                    onFieldSubmitted: (_) => _sendOtp(),
                    decoration: const InputDecoration(
                        labelText: 'Enter Mobile Number',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                            borderSide: BorderSide(width: 2.0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                            borderSide: BorderSide(width: 2.0)),
                        prefixIcon: Icon(Icons.phone, color: Colors.black),
                        prefix: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text('+91'))),
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    _isLoading
                        ? RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100))
                        : RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0)),
                  ),
                  shadowColor: MaterialStateProperty.all(Colors.white),
                  overlayColor: MaterialStateProperty.all(Colors.white),
                  elevation: _buttonActive
                      ? MaterialStateProperty.all(2)
                      : MaterialStateProperty.all(0),
                  surfaceTintColor: MaterialStateProperty.all(Colors.white),
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(
                    _isLoading
                        ? const EdgeInsets.all(12)
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
                    ? const CircularProgressIndicator(
                        strokeWidth: 12,
                        backgroundColor: Colors.blue,
                        color: Colors.black,
                      )
                    : Text(_isOtpSent ? 'Validate Otp' : 'Send Otp',
                        style: const TextStyle(fontSize: 26)),
              ),
              const SizedBox(height: 30),
              if (_isOtpSent)
                ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0))),
                      overlayColor: MaterialStateProperty.all(Colors.white),
                      shadowColor: MaterialStateProperty.all(Colors.white),
                      surfaceTintColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15))),
                  onPressed: reset,
                  child: const Text('Reset', style: TextStyle(fontSize: 26)),
                ),
            ],
          ),
        ),
      );
}
