import 'package:flutter/material.dart';

import 'widget_tree.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ECommerce',
        theme: ThemeData(
          primaryColor: const Color(0xFF283C63),
          secondaryHeaderColor: const Color(0xFFE7E9F5),
          iconTheme: IconThemeData(
            color: Colors.black.withOpacity(0.4),
          ),
        ),
        home: const WidgetTree(),
      );
}
