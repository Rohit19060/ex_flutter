import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(
      MaterialApp(
        title: "Google Auth",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoggedIn = false;
  GoogleSignInAccount? _userObj;
  final GoogleSignIn _googleSignIN = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Auth"),
      ),
      body: _isLoggedIn
          ? Column(
              children: [
                Image.network(_userObj!.photoUrl ?? ""),
                Text(_userObj!.displayName ?? ""),
                Text(_userObj!.email),
                TextButton(
                  onPressed: () {
                    _googleSignIN.signOut().then((value) {
                      setState(() {
                        _isLoggedIn = false;
                      });
                    });
                  },
                  child: const Text("Logout"),
                )
              ],
            )
          : Center(
              child: ElevatedButton(
                child: const Text("Login with Google"),
                onPressed: () {
                  _googleSignIN.signIn().then((value) {
                    setState(() {
                      _isLoggedIn = true;
                      _userObj = value;
                    });
                  }).catchError((e) {});
                },
              ),
            ),
    );
  }
}
