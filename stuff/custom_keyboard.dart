import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: CustomKeyboardExperiment(),
      );
}

class CustomKeyboardExperiment extends StatefulWidget {
  const CustomKeyboardExperiment({super.key});

  @override
  State<CustomKeyboardExperiment> createState() =>
      _CustomKeyboardExperimentState();
}

class _CustomKeyboardExperimentState extends State<CustomKeyboardExperiment> {
  final TextEditingController _controller = TextEditingController();
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
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(1.2),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: <Color>[
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
                    keyboardType: TextInputType.none,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        hintText: 'Enter text',
                        prefix: Text('₹')),
                    controller: _controller,
                    style: const TextStyle(fontSize: 24),
                    autofocus: true,
                    showCursor: true,
                  ),
                ),
              ),
              CustomKeyboard(
                onTextInput: _insertText,
                onBackspace: _backspace,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                    overlayColor: MaterialStatePropertyAll(
                      Colors.black.withOpacity(0.2),
                    ),
                    elevation: const MaterialStatePropertyAll(8),
                    foregroundColor:
                        const MaterialStatePropertyAll(Colors.black),
                    backgroundColor:
                        const MaterialStatePropertyAll(Colors.white),
                    padding: const MaterialStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    ),
                  ),
                  child: const Text(
                    'Submit Amount',
                    style:
                        TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {}),
            ],
          ),
        ),
      );

  void _insertText(String myText) {
    final text = _controller.text;
    final textSelection = _controller.selection;

    // Return if first initial value is 0
    if (myText == '0' && text.isEmpty) {
      return;
    }

    // Return if dot is pressed and already contains a dot
    if (myText == '.' && text.contains('.')) {
      return;
    }
    String newText;
    if (text.isEmpty && myText == '.') {
      newText = '0.';
    } else {
      newText = text.replaceRange(
        textSelection.start,
        textSelection.end,
        myText,
      );
    }
    _controller.value = _controller.value.copyWith(
      text: newText,
      selection: TextSelection(
          baseOffset: newText.length, extentOffset: newText.length),
      composing: TextRange.empty,
    );
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
    final offset =  previousCodeUnit & 0xF800 == 0xD800 ? 2 : 1;
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<num>('currentNumber', currentNumber));
  }
}

class CustomKeyboard extends StatelessWidget {
  const CustomKeyboard({
    super.key,
    required this.onTextInput,
    required this.onBackspace,
  });

  final ValueSetter<String> onTextInput;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 300,
        child: Column(
          children: <Widget>[
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 2.5,
              mainAxisSpacing: 0.2,
              crossAxisSpacing: 0.2,
              children: <String>[
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
                      onPressed: () {
                        onTextInput.call(e);
                      },
                      child: Text(e));
                } else {
                  return TextButton(
                    style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.zero),
                      textStyle:
                          MaterialStatePropertyAll(TextStyle(fontSize: 20)),
                    ),
                    onPressed: onBackspace.call,
                    child: const Icon(
                      Icons.backspace_outlined,
                      color: Colors.black,
                      size: 15,
                    ),
                  );
                }
              }).toList(),
            ),
          ],
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(ObjectFlagProperty<VoidCallback>.has('onBackspace', onBackspace));
    properties.add(ObjectFlagProperty<ValueSetter<String>>.has(
        'onTextInput', onTextInput));
  }
}
