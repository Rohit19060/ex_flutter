import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:platform_device_id/platform_device_id.dart';

final db = FirebaseFirestore.instance;
String? name, id, deviceId;
final formKey = GlobalKey<FormState>();

Widget buildList(DocumentSnapshot doc, int data) {
  final docData = doc.data()! as Map<String, dynamic>;
  return data != 2
      ? deviceId == docData['DeviceId']
          ? Card(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          docData['TimeStamp'].toString(),
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          'Note: ${docData['Note']}',
                          style: const TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        db.collection('Note').doc(doc.id).delete();
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.redAccent,
                      ),
                    )
                  ],
                ),
              ),
            )
          : Container()
      : Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  docData['TimeStamp'].toString(),
                  style: const TextStyle(fontSize: 15),
                ),
                Text(
                  'Note: ${docData['Note']}',
                  style: const TextStyle(fontSize: 22),
                ),
              ],
            ),
          ),
        );
}

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
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          title: const Text(
            "King's Note",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(30),
                child: Text(
                  'Notes',
                  style: TextStyle(fontSize: 30, color: Colors.black),
                ),
              ),
              ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Our Website'),
                  onTap: () => {}),
            ],
          ),
        ),
        body: PageView(
          children: const [Discover(), YourNotes()],
        ),
      ));
}

class Discover extends StatelessWidget {
  const Discover({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          title: const Text(
            'Discover',
            style: TextStyle(color: Colors.black),
          ),
          actions: const [Icon(Icons.chevron_right)],
          backgroundColor: Colors.white,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: db.collection('Note').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data!.docs
                      .map(
                        (doc) => buildList(doc, 2),
                      )
                      .toList(),
                );
              } else {
                return Container();
              }
            }),
      );
}

class YourNotes extends StatefulWidget {
  const YourNotes({super.key});

  @override
  State<YourNotes> createState() => _YourNotesState();
}

class _YourNotesState extends State<YourNotes> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException catch (e) {
      deviceId = e.message;
    }
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _createData() async {
    Navigator.pop(context);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      await db.collection('Note').add({
        'DeviceId': '$deviceId',
        'Note': '$name',
        'TimeStamp': DateFormat('y/M/d H:m:s').format(DateTime.now()),
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.chevron_left),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          title: const Text(
            'Your Notes',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: db.collection('Note').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data!.docs
                      .map(
                        (doc) => buildList(doc, 1),
                      )
                      .toList(),
                );
              } else {
                return const SizedBox();
              }
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Form(
                    key: formKey,
                    child: TextFormField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Note',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return null;
                        }
                        if (value.isEmpty) {
                          return 'Please Enter a Note';
                        }
                        return null;
                      },
                      onSaved: (value) => name = value,
                    ),
                  ),
                  actions: [
                    OutlinedButton(
                      onPressed: _createData,
                      child: const Text(
                        'Add',
                      ),
                    )
                  ],
                ),
              );
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.blueAccent,
            child: const Icon(Icons.add_circle_outline)),
      );
}
