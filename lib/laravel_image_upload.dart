import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? profileImage;
  String url =
      'https://raw.githubusercontent.com/TechMET-Solutions/Developer-Utilities/main/cricstock%20chat.png';
  XFile? _file;

  final picker = ImagePicker();

  bool _loading = false;

  Future<void> getImage(ImageSource img) async {
    final pickedFile = await picker.pickImage(source: img);
    _file = pickedFile;
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
    } else {
      await Fluttertoast.showToast(msg: 'Please Pick a Image');
    }
    setState(() {});
  }

  Future<void> uploadImage() async {
    setState(() => _loading = true);
    final value = await postRequestWithTokenFile(
      fieldName: 'image',
      profilePic: _file!,
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
                    child: profileImage == null
                        ? FadeInImage.assetNetwork(
                            height: 80,
                            width: 80,
                            placeholder: 'assets/images/avatar.jpg',
                            image: url,
                          )
                        : Image.file(
                            profileImage!,
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
                        onTap: () {
                          getImage(ImageSource.gallery);
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_camera),
                        title: const Text('Camera'),
                        onTap: () {
                          getImage(ImageSource.camera);
                          Navigator.of(context).pop();
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
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ImagePicker>('picker', picker));
    properties.add(StringProperty('url', url));
    properties.add(DiagnosticsProperty<File?>('profileImage', profileImage));
  }
}

class ResponseModel {
  ResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  final bool status;
  final String message;
  final dynamic data;

  @override
  String toString() =>
      'ResponseModel{status: $status, message: $message, data: $data}';
}

Future<ResponseModel> postRequestWithTokenFile({
  required XFile profilePic,
  required String fieldName,
}) async {
  try {
    final headers = <String, String>{'content-type': 'application/json'};
    final request = MultipartRequest(
        'POST', Uri.parse('http://192.168.0.121:3000/api/upload'));
    request.headers.addAll(headers);
    request.fields.addAll({});
    request.files.add(await MultipartFile.fromPath(fieldName, profilePic.path));
    final response = await request.send();
    final responseData = await Response.fromStream(response);
    final x = jsonDecode(responseData.body);
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
    return ResponseModel(message: '${e.toString()} 😐', status: false);
  }
}

// Laravel Code
// Route::post("/upload", function (Request $request) {
//     if ($request->hasFile('image')) {
//         $imageName = time() . '.' . $request->image->extension();
//         $request->image->move(public_path('images/test'), $imageName);
//         info("Image uploaded successfully");
//         info($imageName);
//     }
//     return response()->json(["message" => "Image Uploaded Successfully " . $imageName]);
// });
