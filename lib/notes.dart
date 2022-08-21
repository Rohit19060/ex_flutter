import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:platform_device_id/platform_device_id.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const King());
}

class King extends StatelessWidget {
  const King({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const Notes(),
      );
}

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final db = FirebaseFirestore.instance;
  String? _note, _devId;
  final formName = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String? deviceId;
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
    if (!mounted) {
      return;
    }
    setState(() => _devId = deviceId);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: const Text(
            "King's Note - Discover & Share",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: ColoredBox(
          color: Colors.white,
          child: StreamBuilder<QuerySnapshot>(
              stream: db.collection('Note').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      final docData = doc.data()! as Map<String, dynamic>;
                      return Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Card(
                          elevation: 0,
                          child: ListTile(
                            title: Text(
                              docData['Note'].toString(),
                              style: const TextStyle(fontSize: 22),
                            ),
                            subtitle: Text(
                              docData['TimeStamp'].toString(),
                              style: const TextStyle(color: Colors.blue),
                            ),
                            trailing: _devId == docData['DeviceId']
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () {
                                      db
                                          .collection('Note')
                                          .doc(doc.id)
                                          .delete();
                                    })
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return const SizedBox();
                }
              }),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Form(
                  key: formName,
                  child: TextFormField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Note',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please Enter a Note';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) => _note = value,
                  ),
                ),
                actions: [
                  IconButton(
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        if (formName.currentState!.validate()) {
                          formName.currentState!.save();
                          db.collection('Note').add({
                            'DeviceId': _devId,
                            'Note': _note,
                            'TimeStamp': DateFormat('y/M/d H:m:s')
                                .format(DateTime.now()),
                          });
                          Navigator.pop(context);
                        }
                      })
                ],
              ),
            );
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
          child: const Icon(Icons.add_circle_outline),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<GlobalKey<FormState>>('formName', formName));
    properties.add(DiagnosticsProperty<FirebaseFirestore>('db', db));
  }
}
