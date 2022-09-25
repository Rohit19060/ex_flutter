import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

Future<dynamic> networkRequest({
  required String url,
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
    return jsonDecode(response.body);
  } on TimeoutException {
    return {
      'status': 'false',
      'message': 'The connection has timed out, Please try again!'
    };
  } on SocketException {
    debugPrint('No Internet connection! 😑');
    return {'status': 'false', 'message': 'No Internet connection! 😑'};
  } on Exception catch (e) {
    debugPrint('Request Error: $e');
    return {'status': 'false', 'message': 'Connection Problem! 😐'};
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
