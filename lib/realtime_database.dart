import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseDatabase database = FirebaseDatabase.instance;

  DatabaseReference ref = FirebaseDatabase.instance.ref('Match/1');

  @override
  void initState() {
    super.initState();
    final child = ref.child('name');
    debugPrint('child: $child');
    debugPrint('ref.key : ${ref.key}');
    debugPrint('ref.parent?.key : ${ref.parent?.key}');
    _addData();
  }

  Future<void> _addData() async {
    final ref = FirebaseDatabase.instance.ref('Match/1');
    final event = await ref.once();
    debugPrint('event: $event');
    debugPrint('event.snapshot.value ${event.snapshot.value}');

    final stream = ref.onValue;
    stream.listen((event) {
      debugPrint('event: $event');
      debugPrint('event.snapshot.value ${event.snapshot.value}');
    });
  }

  Future<void> _addMSG(String val) async {
    final ref = FirebaseDatabase.instance.ref('Match/1');
    final child = ref.child(Random().nextInt(100).toString());
    await child.set('hello');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: TextFormField(
            decoration: const InputDecoration(labelText: 'Label'),
            onFieldSubmitted: _addMSG,
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DatabaseReference>('ref', ref));
    properties.add(DiagnosticsProperty<FirebaseDatabase>('database', database));
  }
}
