import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseDatabase database = FirebaseDatabase.instance;

  DatabaseReference ref = FirebaseDatabase.instance.ref("Match/1");

  @override
  void initState() {
    super.initState();
    DatabaseReference child = ref.child("name");
    debugPrint("child: $child");
    debugPrint("ref.key : ${ref.key}");
    debugPrint("ref.parent?.key : ${ref.parent?.key}");

    _addData();
  }

  Future _addData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Match/1");
    DatabaseEvent event = await ref.once();
    debugPrint("event: $event");
    debugPrint("event.snapshot.value ${event.snapshot.value}");

    Stream<DatabaseEvent> stream = ref.onValue;
    stream.listen((DatabaseEvent event) {
      debugPrint("event: $event");
      debugPrint("event.snapshot.value ${event.snapshot.value}");
    });
  }

  _addMSG(String val) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Match/1");
    DatabaseReference child = ref.child(Random().nextInt(100).toString());
    child.set("hello");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (_, __) => const Text('Item'),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Label'),
              onFieldSubmitted: (String value) {
                _addMSG(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
