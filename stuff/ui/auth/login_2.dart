import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Login UI',
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: Colors.blue,
          scaffoldBackgroundColor: const Color(0XFFEFF3F6),
        ),
        home: const MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Welcome'),
              const Text(
                'Sign In',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 40.0),
              const Text('Email'),
              const SizedBox(height: 10.0),
              DecoratedBox(
                decoration: BoxDecoration(
                    color: const Color(0XFFEFF3F6),
                    borderRadius: BorderRadius.circular(100.0),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          offset: Offset(6, 2),
                          blurRadius: 6.0,
                          spreadRadius: 3.0),
                      BoxShadow(
                          color: Color.fromRGBO(255, 255, 255, 0.9),
                          offset: Offset(-6, -2),
                          blurRadius: 6.0,
                          spreadRadius: 3.0)
                    ]),
                child: const TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Admin@live.com'),
                ),
              ),
              const SizedBox(height: 30.0),
              const Text('Password'),
              const SizedBox(height: 10.0),
              DecoratedBox(
                decoration: BoxDecoration(
                    color: const Color(0XFFEFF3F6),
                    borderRadius: BorderRadius.circular(100.0),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          offset: Offset(6, 2),
                          blurRadius: 6.0,
                          spreadRadius: 3.0),
                      BoxShadow(
                          color: Color.fromRGBO(255, 255, 255, 0.9),
                          offset: Offset(-6, -2),
                          blurRadius: 6.0,
                          spreadRadius: 3.0)
                    ]),
                child: const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '********',
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              const Text('Forgot Password ?'),
              const SizedBox(height: 30.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(100.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              offset: Offset(6, 2),
                              blurRadius: 6.0,
                              spreadRadius: 3.0),
                          BoxShadow(
                              color: Color.fromRGBO(255, 255, 255, 0.9),
                              offset: Offset(-6, -2),
                              blurRadius: 6.0,
                              spreadRadius: 3.0)
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Log In',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
}
