import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: const LoginScreen(),
    title: 'Firebase Phone Authentication',
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: Colors.blue,
    ),
  ));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobController = TextEditingController(),
      _otpController = TextEditingController();
  bool _isOtpSent = false, _buttonActive = false, _isLoading = false;
  String _verificationID = '';
  User? _user = FirebaseAuth.instance.currentUser;

  Future<void> signInUsingPhone() async {
    if (_otpController.text.length < 6) {
      await Fluttertoast.showToast(msg: 'Please Enter a Valid OTP');
      return;
    }
    try {
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: _verificationID, smsCode: _otpController.text))
          .then((value) {
        Fluttertoast.showToast(msg: 'OTP Verified');
        if (value.user != null && mounted) {
          _user = value.user;
          _isLoading = false;
          setState(() {});
        }
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      reset();
    }
  }

  Future<void> _verifyUser() async {
    setState(() => _isLoading = true);
    if (_isOtpSent) {
      await signInUsingPhone();
    } else {
      await verifyPhone();
    }
  }

  Future<void> verifyPhone() async {
    if (_mobController.text.length < 10) {
      await Fluttertoast.showToast(msg: 'Please Enter a Valid Phone');
      return;
    }
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${_mobController.text}',
      verificationCompleted: (credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null && mounted) {
            setState(() => _user = value.user);
          }
        });
      },
      verificationFailed: (e) => debugPrint(e.message),
      codeSent: (verificationID, resendToken) {
        Fluttertoast.showToast(msg: 'OTP Sent');
        updateVerificationID(verificationID);
      },
      codeAutoRetrievalTimeout: (verificationID) {
        if (mounted) {
          updateVerificationID(verificationID);
        }
      },
      timeout: const Duration(seconds: 120),
    );
  }

  void updateVerificationID(String verificationID) {
    _verificationID = verificationID;
    _isOtpSent = true;
    _buttonActive = false;
    _isLoading = false;
    setState(() {});
  }

  void reset() {
    _mobController.clear();
    _otpController.clear();
    _isOtpSent = false;
    _buttonActive = false;
    _isLoading = false;
    _verificationID = '';
    _user = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Firebase Phone Authentication'),
          centerTitle: true,
          actions: [
            if (_user != null)
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  setState(() => _isLoading = true);
                  await FirebaseAuth.instance.signOut().then((_) {
                    Fluttertoast.showToast(msg: 'Logout Successfully');
                    reset();
                  });
                },
              )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _user != null
                ? [
                    Text('UserId: ${_user!.uid}'),
                    Text('DisplayName: ${_user!.displayName}'),
                    Text('Phone: ${_user!.phoneNumber}')
                  ]
                : [
                    if (_isOtpSent)
                      Center(
                        child: Pinput(
                          defaultPinTheme: PinTheme(
                            width: 56,
                            height: 56,
                            textStyle: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 0, 81, 255),
                                fontWeight: FontWeight.w600),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
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
                          onChanged: (value) => setState(
                              () => _buttonActive = value.length >= 10),
                          maxLength: 10,
                          onFieldSubmitted: (_) => _verifyUser(),
                          decoration: const InputDecoration(
                              labelText: 'Enter Mobile Number',
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2)),
                                  borderSide: BorderSide(width: 2.0)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2)),
                                  borderSide: BorderSide(width: 2.0)),
                              prefixIcon:
                                  Icon(Icons.phone, color: Colors.black),
                              prefix: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Text('+91'))),
                        ),
                      ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStatePropertyAll(
                          _isLoading
                              ? RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100))
                              : RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0)),
                        ),
                        shadowColor:
                            const MaterialStatePropertyAll(Colors.white),
                        overlayColor:
                            const MaterialStatePropertyAll(Colors.white),
                        elevation: _buttonActive
                            ? const MaterialStatePropertyAll(2)
                            : const MaterialStatePropertyAll(0),
                        surfaceTintColor:
                            const MaterialStatePropertyAll(Colors.white),
                        foregroundColor:
                            const MaterialStatePropertyAll(Colors.black),
                        backgroundColor:
                            const MaterialStatePropertyAll(Colors.white),
                        padding:
                            const MaterialStatePropertyAll(EdgeInsets.all(15)),
                      ),
                      onPressed: _buttonActive ? _verifyUser : null,
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
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0))),
                            overlayColor:
                                const MaterialStatePropertyAll(Colors.white),
                            shadowColor:
                                const MaterialStatePropertyAll(Colors.white),
                            surfaceTintColor:
                                const MaterialStatePropertyAll(Colors.white),
                            foregroundColor:
                                const MaterialStatePropertyAll(Colors.black),
                            backgroundColor:
                                const MaterialStatePropertyAll(Colors.white),
                            padding: const MaterialStatePropertyAll(
                                EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15))),
                        onPressed: reset,
                        child:
                            const Text('Reset', style: TextStyle(fontSize: 26)),
                      ),
                  ],
          ),
        ),
      );
}
