import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../firebase_phone_auth.dart';

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

Future<ResponseModel> networkRequest(
  String url, {
  Map<String, String>? formData,
  bool isPost = false,
}) async {
  try {
    final headers = <String, String>{
      HttpHeaders.acceptHeader: 'application/json'
    };
    if (isPost) {
      // Do Authentication Related Stuff like Adding Authentication Token or Id
    }
    Response response;
    if (isPost) {
      response = await post(Uri.parse(url), body: formData, headers: headers);
    } else {
      response = await get(Uri.parse(url), headers: headers);
    }
    return ResponseModel(
        message: '', status: true, data: jsonDecode(response.body));
  } on TimeoutException catch (e) {
    return ResponseModel(message: e.message.toString(), status: false);
  } on SocketException catch (e) {
    return ResponseModel(message: e.message, status: false);
  } on Exception catch (e) {
    debugPrint(e.toString());
    return ResponseModel(message: 'Connection Problem! 😐', status: false);
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}

class KeyPad extends StatelessWidget {
  const KeyPad({
    super.key,
    required this.onTextInput,
    required this.onBackspace,
  });
  final Function(String) onTextInput;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) => GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        mainAxisSpacing: 0.2,
        crossAxisSpacing: 0.2,
        children: [
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '.',
          '0',
          'Clear'
        ].map((e) {
          if (e != 'Clear') {
            return TextButton(
              style: const ButtonStyle(
                textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 20)),
                padding: MaterialStatePropertyAll(EdgeInsets.zero),
              ),
              onPressed: () => onTextInput(e),
              child: Text(
                e,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          } else {
            return TextButton(
              style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.zero),
                textStyle: MaterialStatePropertyAll(
                    TextStyle(fontSize: 20, color: Colors.black)),
              ),
              onPressed: onBackspace.call,
              child: const Icon(
                Icons.backspace_outlined,
                color: Colors.black,
                size: 24,
              ),
            );
          }
        }).toList(),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(ObjectFlagProperty<VoidCallback>.has('onBackspace', onBackspace));
    properties.add(ObjectFlagProperty<Function(String p1)>.has(
        'onTextInput', onTextInput));
  }
}

double getTextWidth(BuildContext context, String text, TextStyle? style) {
  final span = TextSpan(text: text, style: style);
  const constraints = BoxConstraints();
  final richTextWidget = Text.rich(span).build(context) as RichText;
  final renderObject = richTextWidget.createRenderObject(context);
  renderObject.layout(constraints);
  final renderBoxes = renderObject.getBoxesForSelection(
    TextSelection(
      baseOffset: 0,
      extentOffset: TextSpan(text: text).toPlainText().length,
    ),
  );
  return renderBoxes.last.right;
}

// Local Notification Methods
final FlutterLocalNotificationsPlugin _notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initialize() {
  const initializationSettingsAndroid = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_launcher'));
  _notificationsPlugin.initialize(initializationSettingsAndroid);
}

Future<void> display(RemoteMessage message) async {
  try {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
          message.notification!.android!.sound ?? 'Channel Id',
          message.notification!.android!.sound ?? 'Main Channel',
          groupKey: 'notificationGroup',
          color: Colors.blue,
          importance: Importance.max,
          sound: RawResourceAndroidNotificationSound(
              message.notification!.android!.sound),
          priority: Priority.high),
    );
    await _notificationsPlugin.show(id, message.notification?.title,
        message.notification?.body, notificationDetails,
        payload: message.data['route'].toString());
  } on Exception catch (e) {
    debugPrint(e.toString());
  }
}

void notificationRouter(String route, int situation) {
  // navigatorKey.currentState?.pushNamed(homeRoute, arguments: {'index': 2});
}

Future<String> downloadAndSaveFile(String url, String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$fileName';
  final response = await get(Uri.parse(url));
  final file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

Future<bool> requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    final result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
  }
  return false;
}

Future<void> downloadFileToDownloads(String url, String name) async {
  final directory = await getApplicationDocumentsDirectory();
  final response = await get(Uri.parse(url));
  final headers = response.headers;
  final contentType = headers['content-type'];
  final extension = contentType?.split('/').last;
  final file = File('${directory.path}/$name.$extension');
  file.writeAsBytesSync(response.bodyBytes);
  try {
    if (await requestPermission(Permission.accessMediaLocation)) {
      final downloadDirectory = Directory('/storage/emulated/0/Download');
      if (!downloadDirectory.existsSync()) {
        downloadDirectory.createSync();
      }
      final newFile = File('${downloadDirectory.path}/$name.pdf');
      await file.copy(newFile.path);
      showToast('Downloaded to Download folder');
    }
  } on Exception catch (e) {
    showToast(e.toString());
  }
}

Future<DateTime> datePicker(BuildContext context) async {
  final data = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1950),
    lastDate: DateTime(DateTime.now().year - 13),
  ).catchError((e) {
    debugPrint('Select Date Error: $e');
    return null;
  }).onError((error, stackTrace) {
    debugPrint('Select Date Error: $error');
    return null;
  });
  return data ?? DateTime.now();
}

Future<TimeOfDay> timePicker(BuildContext context) async {
  final data = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  ).catchError((e) {
    debugPrint('Select Date Error: $e');
    return null;
  }).onError((error, stackTrace) {
    debugPrint('Select Date Error: $error');
    return null;
  });
  return data ?? TimeOfDay.now();
}

Future<void> singleActionDialog(
        BuildContext context, String text, Function() onConfirmTap) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actionsOverflowButtonSpacing: 2,
        actionsOverflowDirection: VerticalDirection.down,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge),
        actions: [
          OutlinedButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30)),
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
              onPressed: () {
                onConfirmTap();
                Navigator.pop(context);
              },
              child: const Text('Ok', textAlign: TextAlign.center))
        ],
      ),
    );

Future<void> doubleActionDialog(
        BuildContext context, String text, Function() onConfirmTap) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actionsOverflowButtonSpacing: 2,
        actionsOverflowDirection: VerticalDirection.down,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium),
        actions: [
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
                foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).secondaryHeaderColor),
              ),
              onPressed: () {
                onConfirmTap();
                Navigator.pop(context);
              },
              child: const Text('Confirm', textAlign: TextAlign.center)),
          ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', textAlign: TextAlign.center))
        ],
      ),
    );

Future<void> inputDialog(BuildContext context, String text,
    VoidCallback onConfirmTap, TextEditingController controller) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actionsOverflowButtonSpacing: 2,
      actionsOverflowDirection: VerticalDirection.down,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.12,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Reason',
                hintText: 'Enter Reason',
                labelStyle: Theme.of(context).textTheme.titleMedium,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
      actions: [
        OutlinedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30)),
                backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
            onPressed: () {
              onConfirmTap();
              Navigator.pop(context);
            },
            child: const Text(
              'Update',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            )),
      ],
    ),
  );
}
