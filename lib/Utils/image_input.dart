import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onSelectImage});
  final Function(File) onSelectImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<Function>('onSelectImage', onSelectImage));
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    await picker
        .pickImage(source: ImageSource.camera, maxWidth: 600)
        .then((pickedImage) async {
      if (pickedImage == null) {
        return;
      }
      setState(() {
        _storedImage = File(pickedImage.path);
      });
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = basename(pickedImage.path);
      final savedImage =
          await File(pickedImage.path).copy('${appDir.path}/$fileName');
      widget.onSelectImage(savedImage);
    });
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            alignment: Alignment.center,
            child: _storedImage != null
                ? Image.file(
                    _storedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : const Text('No Image Selected', textAlign: TextAlign.center),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _takePicture,
              icon: const Icon(Icons.camera),
              label: const Text('Add Image'),
            ),
          ),
        ],
      );
}
