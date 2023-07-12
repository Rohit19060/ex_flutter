import 'package:flutter/material.dart';

import 'laravel_image_upload.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Experiments',
        theme: ThemeData(useMaterial3: true),
        home: const ImageInput(),
      );
}
