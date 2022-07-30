import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(
    MaterialApp(routes: <String, WidgetBuilder>{
      '/': (BuildContext context) => _ExampleList(),
      '/$PictureScanner': (BuildContext context) => const PictureScanner(),
    }),
  );
}

class _ExampleList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ExampleListState();
}

class _ExampleListState extends State<_ExampleList> {
  static final List<String> _exampleWidgetNames = <String>[
    '$PictureScanner',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example List'),
      ),
      body: ListView.builder(
        itemCount: _exampleWidgetNames.length,
        itemBuilder: (BuildContext context, int index) {
          final String widgetName = _exampleWidgetNames[index];

          return Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: ListTile(
              title: Text(widgetName),
              onTap: () => Navigator.pushNamed(context, '/$widgetName'),
            ),
          );
        },
      ),
    );
  }
}

class PictureScanner extends StatefulWidget {
  const PictureScanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PictureScannerState();
}

class _PictureScannerState extends State<PictureScanner> {
  File? _imageFile;
  List<Face> _scanResults = [];
  final FaceDetector _faceDetector = GoogleVision.instance.faceDetector();
  var picker = ImagePicker();

  Future<void> _getAndScanImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    _imageFile = File(pickedImage.path);
    await _scanImage(_imageFile!);
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  Future<void> _scanImage(File imageFile) async {
    final GoogleVisionImage visionImage = GoogleVisionImage.fromFile(imageFile);
    _scanResults = await _faceDetector.processImage(visionImage);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picture Scanner')),
      body: _scanResults.isEmpty
          ? const Center(child: Text('No image selected.'))
          : BuildImage(scanResults: _scanResults, imageFile: _imageFile),
      floatingActionButton: FloatingActionButton(
        onPressed: _getAndScanImage,
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}

class BuildImage extends StatelessWidget {
  final File? imageFile;
  final List<Face> scanResults;
  const BuildImage({
    Key? key,
    this.imageFile,
    required this.scanResults,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imageFile != null
        ? Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.file(imageFile!).image,
                fit: BoxFit.fitWidth,
              ),
            ),
            child: scanResults.isEmpty
                ? const Center(
                    child: Text(
                      'Scanning...',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 30,
                      ),
                    ),
                  )
                : Text('Face Count:${scanResults.length}'),
          )
        : const Text('No Image Selected');
  }
}
