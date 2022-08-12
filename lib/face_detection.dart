import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(
    MaterialApp(routes: <String, WidgetBuilder>{
      '/': (context) => _ExampleList(),
      '/$PictureScanner': (context) => const PictureScanner(),
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
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Example List'),
        ),
        body: ListView.builder(
          itemCount: _exampleWidgetNames.length,
          itemBuilder: (context, index) {
            final widgetName = _exampleWidgetNames[index];
            return DecoratedBox(
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

class PictureScanner extends StatefulWidget {
  const PictureScanner({super.key});

  @override
  State<StatefulWidget> createState() => _PictureScannerState();
}

class _PictureScannerState extends State<PictureScanner> {
  File? _imageFile;
  List<Face> _scanResults = <Face>[];
  final FaceDetector _faceDetector = GoogleVision.instance.faceDetector();
  ImagePicker picker = ImagePicker();

  Future<void> _getAndScanImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return;
    }
    _imageFile = File(pickedImage.path);
    await _scanImage(_imageFile!);
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  Future<void> _scanImage(File imageFile) async {
    final visionImage = GoogleVisionImage.fromFile(imageFile);
    _scanResults = await _faceDetector.processImage(visionImage);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ImagePicker>('picker', picker));
  }
}

class BuildImage extends StatelessWidget {
  const BuildImage({
    super.key,
    this.imageFile,
    required this.scanResults,
  });
  final File? imageFile;
  final List<Face> scanResults;

  @override
  Widget build(BuildContext context) => imageFile != null
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
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<Face>('scanResults', scanResults));
    properties.add(DiagnosticsProperty<File?>('imageFile', imageFile));
  }
}
