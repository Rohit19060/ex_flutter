import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Ellipse',
        theme: ThemeData(useMaterial3: true, primarySwatch: Colors.blue),
        home: const Scaffold(
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: EllipseText(
                text:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
              ),
            ),
          ),
        ),
      );
}

class EllipseText extends StatefulWidget {
  const EllipseText({super.key, required this.text, this.trimLines = 3});
  final String text;
  final int trimLines;

  @override
  EllipseTextState createState() => EllipseTextState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('trimLines', trimLines));
    properties.add(StringProperty('text', text));
  }
}

class EllipseTextState extends State<EllipseText> {
  bool ellipseText = true;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final textPainter = TextPainter(
            text: TextSpan(
              text: ellipseText ? ' ...read more' : ' ...read less',
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () => setState(() => ellipseText = !ellipseText),
            ),
            textDirection: TextDirection.rtl,
            maxLines: widget.trimLines,
            ellipsis: '...',
          );
          textPainter.layout(
              minWidth: constraints.minWidth, maxWidth: constraints.maxWidth);
          final linkSize = textPainter.size;
          textPainter.text = TextSpan(text: widget.text);
          textPainter.layout(
              minWidth: constraints.minWidth, maxWidth: constraints.maxWidth);
          final textSize = textPainter.size;
          final pos = textPainter.getPositionForOffset(
              Offset(textSize.width - linkSize.width, textSize.height));
          final endIndex = textPainter.getOffsetBefore(pos.offset)!;
          TextSpan textSpan;
          if (textPainter.didExceedMaxLines) {
            textSpan = TextSpan(
              text: ellipseText
                  ? widget.text.substring(0, endIndex)
                  : widget.text,
              style: const TextStyle(color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: ellipseText ? ' ...read more' : ' ...read less',
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap =
                          () => setState(() => ellipseText = !ellipseText))
              ],
            );
          } else {
            textSpan = TextSpan(text: widget.text);
          }
          return RichText(text: textSpan);
        },
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('ellipseText', ellipseText));
  }
}
