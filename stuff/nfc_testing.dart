import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NFCTesting extends StatefulWidget {
  const NFCTesting({super.key});

  @override
  State<StatefulWidget> createState() => NFCTestingState();
}

class NFCTestingState extends State<NFCTesting> {
  ValueNotifier<dynamic> result = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    NfcManager.instance.isAvailable().then((v) {
      debugPrint(v.toString());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('NfcManager Plugin Example')),
          body: SafeArea(
            child: FutureBuilder<bool>(
              future: NfcManager.instance.isAvailable(),
              builder: (context, ss) => ss.data != true
                  ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))
                  : Flex(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      direction: Axis.vertical,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            constraints: const BoxConstraints.expand(),
                            decoration: BoxDecoration(border: Border.all()),
                            child: SingleChildScrollView(
                              child: ValueListenableBuilder<dynamic>(
                                valueListenable: result,
                                builder: (context, value, _) => Text('${value ?? ''}'),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: GridView.count(
                            padding: const EdgeInsets.all(4),
                            crossAxisCount: 2,
                            childAspectRatio: 4,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                            children: [
                              ElevatedButton(onPressed: _tagRead, child: const Text('Tag Read')),
                              ElevatedButton(onPressed: _ndefWrite, child: const Text('Ndef Write')),
                              ElevatedButton(onPressed: _ndefWriteLock, child: const Text('Ndef Write Lock')),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      );

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (tag) async {
      result.value = tag.data;
      await NfcManager.instance.stopSession();
    });
  }

  void _ndefWrite() {
    NfcManager.instance.startSession(
        alertMessage: 'Ready to write',
        onError: (error) {
          result.value = error;
          return Future.value();
        },
        pollingOptions: {
          NfcPollingOption.iso14443,
        },
        onDiscovered: (tag) async {
          final ndef = Ndef.from(tag);
          if (ndef == null || !ndef.isWritable) {
            result.value = 'Tag is not ndef writable';
            await NfcManager.instance.stopSession(errorMessage: result.value.toString());
            return;
          }

          final message = NdefMessage([
            NdefRecord.createText('Hello World!'),
            NdefRecord.createUri(Uri.parse('https://flutter.dev')),
            NdefRecord.createMime('text/plain', Uint8List.fromList('Hello'.codeUnits)),
            NdefRecord.createExternal('com.example', 'x', Uint8List.fromList('x'.codeUnits)),
          ]);

          try {
            await ndef.write(message);
            result.value = 'Success to "Ndef Write"';
            await NfcManager.instance.stopSession();
          } on Exception catch (e) {
            result.value = e;
            await NfcManager.instance.stopSession(errorMessage: result.value.toString());
            return;
          }
        });
  }

  void _ndefWriteLock() {
    NfcManager.instance.startSession(onDiscovered: (tag) async {
      final ndef = Ndef.from(tag);
      if (ndef == null) {
        result.value = 'Tag is not ndef';
        await NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }

      try {
        await ndef.writeLock();
        result.value = 'Success to "Ndef Write Lock"';
        await NfcManager.instance.stopSession();
      } on Exception catch (e) {
        result.value = e;
        await NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // ignore: strict_raw_type
    properties.add(DiagnosticsProperty<ValueNotifier>('result', result));
  }
}
