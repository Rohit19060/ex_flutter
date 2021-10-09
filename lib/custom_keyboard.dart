import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CustomKeyboardExperiment(),
    );
  }
}

class CustomKeyboardExperiment extends StatefulWidget {
  const CustomKeyboardExperiment({Key? key}) : super(key: key);

  @override
  _CustomKeyboardExperimentState createState() =>
      _CustomKeyboardExperimentState();
}

class _CustomKeyboardExperimentState extends State<CustomKeyboardExperiment> {
  final TextEditingController _controller = TextEditingController();
  final bool _readOnly = true;
  num currentNumber = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        currentNumber = double.tryParse(_controller.text) ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.all(1.2),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color.fromRGBO(31, 169, 250, 1),
                    Color.fromRGBO(55, 100, 235, 1)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  borderRadius: BorderRadius.circular(5)),
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      hintText: 'Enter text',
                      prefix: Text("₹")),
                  controller: _controller,
                  style: const TextStyle(fontSize: 24),
                  autofocus: true,
                  showCursor: true,
                  readOnly: true,
                ),
              ),
            ),
            CustomKeyboard(
              onTextInput: (myText) {
                _insertText(myText);
              },
              onBackspace: () {
                _backspace();
              },
            ),
            ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                  overlayColor: MaterialStateProperty.all(
                    Colors.black.withOpacity(0.2),
                  ),
                  elevation: MaterialStateProperty.all(8),
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  ),
                ),
                child: const Text(
                  "Submit Amount",
                  style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  print(_controller.text);
                }),
          ],
        ),
      ),
    );
  }

  void _insertText(String myText) {
    final text = _controller.text;
    final textSelection = _controller.selection;

    // Return if first initial value is 0
    if (myText == "0" && text.isEmpty) {
      return;
    }

    // Return if dot is pressed and already contains a dot
    if (myText == "." && text.contains(".")) {
      return;
    }

    final myTextLength = myText.length;
    if (text.isEmpty && myText == ".") {
      _controller.text = "0.";
      _controller.selection = textSelection.copyWith(
        baseOffset: textSelection.start + myTextLength + 1,
        extentOffset: textSelection.start + myTextLength + 1,
      );
    } else {
      final newText = text.replaceRange(
        textSelection.start,
        textSelection.end,
        myText,
      );
      _controller.text = newText;
      _controller.selection = textSelection.copyWith(
        baseOffset: textSelection.start + myTextLength,
        extentOffset: textSelection.start + myTextLength,
      );
    }
  }

  void _backspace() {
    final text = _controller.text;
    final textSelection = _controller.selection;
    final selectionLength = textSelection.end - textSelection.start;

    // There is a selection.
    if (selectionLength > 0) {
      final newText = text.replaceRange(
        textSelection.start,
        textSelection.end,
        '',
      );
      _controller.text = newText;
      _controller.selection = textSelection.copyWith(
        baseOffset: textSelection.start,
        extentOffset: textSelection.start,
      );
      return;
    }

    // The cursor is at the beginning.
    if (textSelection.start == 0) {
      return;
    }

    // Delete the previous character
    final previousCodeUnit = text.codeUnitAt(textSelection.start - 1);
    final offset = _isUtf16Surrogate(previousCodeUnit) ? 2 : 1;
    final newStart = textSelection.start - offset;
    final newEnd = textSelection.start;
    final newText = text.replaceRange(
      newStart,
      newEnd,
      '',
    );
    _controller.text = newText;
    _controller.selection = textSelection.copyWith(
      baseOffset: newStart,
      extentOffset: newStart,
    );
  }

  bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CustomKeyboard extends StatelessWidget {
  const CustomKeyboard({
    Key? key,
    required this.onTextInput,
    required this.onBackspace,
  }) : super(key: key);

  final ValueSetter<String> onTextInput;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          GridView.count(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              "1",
              "2",
              "3",
              "4",
              "5",
              "6",
              "7",
              "8",
              "9",
              ".",
              "0",
              "Clear"
            ].map((e) {
              if (e != "Clear") {
                return TextButton(
                    onPressed: () {
                      onTextInput.call(e);
                    },
                    child: Text(e));
              } else {
                return TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    textStyle: MaterialStateProperty.all(
                        const TextStyle(fontSize: 20)),
                  ),
                  onPressed: () {
                    onBackspace.call();
                  },
                  child: const Icon(
                    Icons.backspace_outlined,
                    color: Colors.black,
                    size: 15,
                  ),
                );
              }
            }).toList(),
            crossAxisCount: 3,
            childAspectRatio: 2.5,
            mainAxisSpacing: 0.2,
            crossAxisSpacing: 0.2,
          ),
        ],
      ),
    );
  }
}
