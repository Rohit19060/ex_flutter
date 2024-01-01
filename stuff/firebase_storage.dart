import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as e;

UploadTask uploadFile(String destination, File file) {
  final ref = FirebaseStorage.instance.ref(destination);
  return ref.putFile(file);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Storage());
}

class Storage extends StatefulWidget {
  const Storage({super.key});

  @override
  State<Storage> createState() => _StorageState();
}

class _StorageState extends State<Storage> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const StorageHome(),
      );
}

class StorageHome extends StatefulWidget {
  const StorageHome({super.key});

  @override
  State<StorageHome> createState() => _StorageHomeState();
}

class _StorageHomeState extends State<StorageHome> {
  UploadTask? task;
  File? file;

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? e.basename(file!.path) : 'No file Selected';
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: _selectFile,
                icon: const Icon(Icons.upload_file_outlined),
                label: const Text('Select File'),
              ),
              const SizedBox(height: 28),
              Text(
                fileName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 28),
              OutlinedButton.icon(
                onPressed: _uploadFile,
                icon: const Icon(Icons.upload),
                label: const Text('Upload File'),
              ),
              const SizedBox(height: 20),
              if (task != null) buildUploadStatus(task!) else const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    }
    final path = result.files.single.path!;
    setState(() => file = File(path));
  }

  Future<void> _uploadFile() async {
    if (file == null) {
      return;
    }
    final fileName = e.basename(file!.path);
    final destination = 'files/$fileName';
    task = uploadFile(destination, file!);
    setState(() {});
    if (task == null) {
      return;
    }
    // final snapshot = await task!.whenComplete(() {});
    // final urlDownload = await snapshot.ref.getDownloadURL();
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);
            return Text(
              '$percentage %',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return const SizedBox();
          }
        },
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<File?>('file', file));
    properties.add(DiagnosticsProperty<UploadTask?>('task', task));
  }
}
