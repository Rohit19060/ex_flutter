import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Image Cropper',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: const ImageCropTemplate(),
      );
}

class ShowFile extends StatelessWidget {
  const ShowFile({super.key, this.file});
  final File? file;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(child: Image.file(file!)),
        floatingActionButton: FloatingActionButton(
          onPressed: saveImage,
        ),
      );

  Future<void> saveImage() async {
    await getExternalStorageDirectories().then((value) {
      final fileName = p.basename(file!.path);
      file!.copy('${value!.first.path}/$fileName');
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<File?>('file', file));
  }
}

enum AppState { select, crop, save }

class ImageCropTemplate extends StatefulWidget {
  const ImageCropTemplate({super.key});

  @override
  State<ImageCropTemplate> createState() => _ImageCropTemplateState();
}

class _ImageCropTemplateState extends State<ImageCropTemplate> {
  final cropKey = GlobalKey<CropState>();
  File? _file;
  File? _sample;
  File? _lastCropped;
  final picker = ImagePicker();
  AppState appState = AppState.select;
  @override
  void dispose() {
    super.dispose();
    _file?.delete();
    _sample?.delete();
    _lastCropped?.delete();
  }

  @override
  void initState() {
    super.initState();
    ImageCrop.requestPermissions();
  }

  Widget getCenterWidget() {
    if (appState == AppState.select) {
      return const Text(
        'Please select Image to Crop ',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      );
    } else if (appState == AppState.crop) {
      return _buildCroppingImage();
    } else {
      return Center(child: Image.file(_lastCropped!));
    }
  }

  IconData getIcon() {
    if (appState == AppState.select) {
      return Icons.add;
    } else if (appState == AppState.crop) {
      return Icons.crop;
    } else {
      return Icons.save;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(child: getCenterWidget()),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _sample == null ? _openImage(context) : _cropImage(cropKey);
          },
          child: Icon(getIcon()),
        ),
        bottomNavigationBar: _sample != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ElevatedButton(
                    onPressed: () => _openImage(context),
                    child: const Text('Select Other Image')))
            : null,
      );

  Widget _buildCroppingImage() =>
      Crop.file(_sample!, key: cropKey, maximumScale: 10);

  Future<void> _openImage(BuildContext context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final file = File(pickedFile!.path);
    final sample = await ImageCrop.sampleImage(
      file: file,
      preferredSize: context.size?.longestSide.ceil(),
    );

    await _sample?.delete();
    await _file?.delete();

    setState(() {
      _sample = sample;
      _file = file;
      appState = AppState.crop;
    });
  }

  Future<void> _cropImage(GlobalKey<CropState> cropKey) async {
    final scale = cropKey.currentState?.scale;
    final area = cropKey.currentState?.area;
    if (area == null || scale == null) {
      // cannot crop, widget is not setup
      return;
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    final sample = await ImageCrop.sampleImage(
      file: _file!,
      preferredSize: (2000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    await sample.delete();

    await _lastCropped?.delete();

    setState(() {
      _lastCropped = file;
      appState = AppState.save;
    });
    debugPrint('$file');
  }

  Future<void> saveImage() async {
    await getExternalStorageDirectories().then((value) {
      final fileName = p.basename(_lastCropped!.path);
      _lastCropped!.copy('${value!.first.path}/$fileName');
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<AppState>('appState', appState));
    properties.add(DiagnosticsProperty<ImagePicker>('picker', picker));
    properties
        .add(DiagnosticsProperty<GlobalKey<CropState>>('cropKey', cropKey));
  }
}
