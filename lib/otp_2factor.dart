import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pinput/pinput.dart';

class Otp2Factor {
  static Future sendRequest(String url) async {
    try {
      var response =
          await get(Uri.parse(url), headers: {'Accept': 'application/json'});
      return json.decode(response.body);
    } on SocketException {
      return {
        'Status': 'Internet Issue',
        'Details': 'No Internet connection 😑'
      };
    } catch (e) {
      return {'Status': 'Server Problem', 'Details': 'Connection Error 😑'};
    }
  }

  static Future sendOtp({required String mob}) {
    return sendRequest(
        "https://2factor.in/API/V1/${dotenv.env['otpkey']}/SMS/$mob/AUTOGEN");
  }

  static Future validateOTP({required String sessionId, required String otp}) {
    return sendRequest(
        "https://2factor.in/API/V1/${dotenv.env['otpkey']}/SMS/VERIFY/$sessionId/$otp");
  }
}

Future main() async {
  await dotenv.load(fileName: 'lib/.env');
  runApp(const MaterialApp(home: HomePage()));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
    Otp2Factor.sendOtp(mob: _mobController.text.toString()).then((value) {
      if (value['Status'] == 'Success') {
        Fluttertoast.showToast(msg: 'Otp Sent Successfully');
        _isOtpSent = true;
        _sessionId = value['Details'];
        _buttonActive = false;
      } else {
        Fluttertoast.showToast(msg: value['Details']);
      }
      setState(() => _isLoading = false);
    });
  }

  void _validateOTP() {
    setState(() => _isLoading = true);
    Otp2Factor.validateOTP(otp: _otpController.text, sessionId: _sessionId)
        .then((value) {
      if (value['Status'] == 'Success') {
        Fluttertoast.showToast(msg: 'Mobile Number Verified');
        _isOtpSent = false;
        _sessionId = '';
        _mobController.text = '';
        _otpController.text = '';
        _buttonActive = false;
      } else {
        Fluttertoast.showToast(msg: value['Details']);
      }
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            _isOtpSent
                ? Pinput(
                    autofocus: _isOtpSent,
                    controller: _otpController,
                    androidSmsAutofillMethod:
                        AndroidSmsAutofillMethod.smsUserConsentApi,
                    onClipboardFound: (String value) {
                      _otpController.text = value;
                    },
                    closeKeyboardWhenCompleted: true,
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
                    keyboardType: TextInputType.number,
                    pinAnimationType: PinAnimationType.scale,
                  )
                : TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Enter Mobile Number',
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),
                        ),
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),
                        ),
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
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
}
