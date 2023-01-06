import 'package:flutter/material.dart';

import 'utils/password_view.dart';

void main() async => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Rotational Password Dialer',
        theme: ThemeData(useMaterial3: true),
        home: PasswordInputView(
          expectedCode: '7412',
          onSuccess: () {},
          onError: () {},
        ),
      );
}
