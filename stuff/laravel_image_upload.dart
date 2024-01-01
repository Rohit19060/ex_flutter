import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'utilities/methods.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _profileImage;

  final _picker = ImagePicker();
  final _cropper = ImageCropper();
  bool _loading = false;

  Future<void> getImage(ImageSource img) async {
    final pickedFile = await _picker.pickImage(source: img);
    if (pickedFile == null) {
      await Fluttertoast.showToast(msg: 'Please Pick a Image');
      return;
    }
    final croppedFile = await _cropper.cropImage(
      maxHeight: 200,
      maxWidth: 200,
      uiSettings: [
        AndroidUiSettings(
          toolbarWidgetColor: Colors.white,
          statusBarColor: Colors.blue,
          toolbarColor: Colors.blue,
          toolbarTitle: 'Crop the Image',
        ),
      ],
      sourcePath: CroppedFile(pickedFile.path).path,
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 4),
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio5x3,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.square
      ],
      compressQuality: 30,
    );
    if (croppedFile == null) {
      await Fluttertoast.showToast(msg: 'Please Pick a Image');
      return;
    }
    _profileImage = File(croppedFile.path);
    setState(() {});
  }

  Future<void> uploadImage() async {
    setState(() => _loading = true);
    final value = await postRequestWithImage(
      fieldName: 'image',
      profilePic: _profileImage!,
    );
    await Fluttertoast.showToast(msg: value.message);
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Laravel Image Upload',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Laravel Image Upload'),
                ClipOval(
                  child: ColoredBox(
                    color: Colors.grey.shade200,
                    child: _profileImage == null
                        ? FadeInImage.assetNetwork(
                            height: 80,
                            width: 80,
                            placeholder: 'assets/images/avatar.jpg',
                            image:
                                'https://avatars.githubusercontent.com/u/39453065?v=4',
                          )
                        : Image.file(
                            _profileImage!,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SafeArea(
                  child: Wrap(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text('Photo Library'),
                        onTap: () async {
                          await getImage(ImageSource.gallery);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_camera),
                        title: const Text('Camera'),
                        onTap: () async {
                          await getImage(ImageSource.camera);
                        },
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                    onPressed: uploadImage,
                    child: _loading
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : const Text('Upload'))
              ],
            ),
          ),
        ),
      );
}

Future<ResponseModel> postRequestWithImage({
  required File profilePic,
  required String fieldName,
}) async {
  try {
    final headers = <String, String>{'content-type': 'application/json'};
    final request = MultipartRequest(
        'POST', Uri.parse('http://192.168.29.5:8000/api/upload'));
    request.headers.addAll(headers);
    request.fields.addAll({});
    request.files.add(await MultipartFile.fromPath(fieldName, profilePic.path));
    final response = await request.send();
    final responseData = await Response.fromStream(response);
    final x = jsonDecode(responseData.body) as Map<String, dynamic>;
    if (response.statusCode < 400) {
      return ResponseModel(
        message: x['message'].toString(),
        status: true,
      );
    } else {
      return ResponseModel(message: x['message'].toString(), status: false);
    }
  } on TimeoutException catch (e) {
    return ResponseModel(message: e.message.toString(), status: false);
  } on SocketException catch (e) {
    return ResponseModel(message: e.message, status: false);
  } on Exception catch (e) {
    return ResponseModel(message: '$e 😐', status: false);
  }
}

// Laravel Code
// Route::post("/upload", function (Request $request) {
//     if ($request->hasFile('image')) {
//         $imageName = time() . '.' . $request->image->extension();
//         $request->image->move(public_path('images/test'), $imageName);
//         info("Image uploaded successfully");
//         info($imageName);
//         return response()->json(["message" => "Image Uploaded Successfully " . $imageName]);
//     }
//     return response()->json(["message" => "Image Field Not Found"]);
// });
