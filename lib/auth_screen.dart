import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Experiments',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const Scaffold(body: AuthScreen()),
      );
}

enum AuthMode { signUp, login }

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.amber.withOpacity(0.5),
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 94.0),
                  transform: Matrix4.rotationZ(-6 * pi / 180)..translate(-10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.deepOrange.shade900,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: const Text(
                    'MyShop',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontFamily: 'Anton',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: deviceSize.width > 600 ? 2 : 1,
                child: const AuthCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    super.key,
  });

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController? _controller;
  late Animation<Offset>? _slideAnimation;
  late Animation<double>? _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    // _heightAnimation = Tween<Size>(
    //         begin: Size(double.infinity, 260), end: Size(double.infinity, 320))
    //     .animate(
    //         CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn));
    // _heightAnimation?.addListener(() {
    //   setState(() {});
    // });
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn));
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1.5), end: Offset.zero).animate(
            CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn));
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Error Occurred'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Okay'))
              ],
            ));
  }

  Future<void> _submit() async {
    // if (!_formKey.currentState!.validate()) {
    //   return;
    // }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.login) {
        debugPrint('Login');
        debugPrint("Email: ${_authData['email']}");
        debugPrint("Password: ${_authData['password']}");
      } else {
        debugPrint('SignUp');
        debugPrint("Email: ${_authData['email']}");
        debugPrint("Password: ${_authData['password']}");
      }
    } on HttpException catch (e) {
      var message = 'Authentication Failed';
      if (e.toString().contains('EMAIL_EXISTS')) {
        message = 'Email already exists';
      } else if (e.toString().contains('INVALID_EMAIL')) {
        message = 'This is not a valid email address';
      } else if (e.toString().contains('WEAK_PASSWORD')) {
        message = 'Password is too weak';
      } else if (e.toString().contains('EMAIL_NOT_FOUND')) {
        message = 'Could not find a user with that email';
      } else if (e.toString().contains('INVALID_PASSWORD')) {
        message = 'Invalid password';
      }
      _showErrorDialog(message);
    } on Exception catch (e) {
      debugPrint(e.toString());
      const message = 'Could not authenticate you. Please try again later.';
      _showErrorDialog(message);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
      _controller?.forward();
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      _controller?.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        height: _authMode == AuthMode.signUp ? 320 : 260,
        // height: _heightAnimation!.value.height,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.signUp ? 320 : 260,
        ),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.isEmpty ||
                        value != null && !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value != null && value.isEmpty ||
                        value != null && value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.signUp ? 60 : 0,
                      maxHeight: _authMode == AuthMode.signUp ? 120 : 0),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation!,
                    child: SlideTransition(
                      position: _slideAnimation!,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.signUp,
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: _authMode == AuthMode.signUp
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                                return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 8.0),
                    ),
                    onPressed: _submit,
                    child:
                        Text(_authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP'),
                  ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: _switchAuthMode,
                  child: Text(
                      '${_authMode == AuthMode.login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
