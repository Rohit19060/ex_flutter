import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class ThemeCardExample extends StatefulWidget {
  const ThemeCardExample({super.key});

  @override
  State<ThemeCardExample> createState() => _ThemeCardExampleState();
}

class _ThemeCardExampleState extends State<ThemeCardExample> {
  late String _index = 'Filled Green';
  bool postalCodeEnabled = false;

  Map<String, ThemeData> get themes => {
        'Default': ThemeData.light().copyWith(),
        'Filled Green': ThemeData(
          primaryColor: Colors.green,
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
          ),
          colorScheme: const ColorScheme.light(
            primary: Colors.green,
            secondary: Colors.green,
            error: Colors.red,
          ).copyWith(error: Colors.red),
        ),
        'Outlined': ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
            contentPadding: EdgeInsets.all(12),
            border: OutlineInputBorder(),
          ),
        ),
        'Filled with label': ThemeData.light().copyWith(
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.all(12),
          ),
        ),
        'Dark': ThemeData(
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(secondary: Colors.purpleAccent),
        ),
        'Dark filled': ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(secondary: Colors.blue[200]!),
          inputDecorationTheme: InputDecorationTheme(
            focusColor: Colors.red,
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            hintStyle: TextStyle(color: Colors.blue[100]),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue[100]!),
            ),
            isCollapsed: true,
          ),
        ),
      };
  @override
  Widget build(BuildContext context) {
    final theme = themes[_index]!;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Theme(
            data: theme,
            child: Container(
              height: 150,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              color: theme.scaffoldBackgroundColor,
              child: CardField(
                autofocus: true,
                enablePostalCode: postalCodeEnabled,
                style: const TextStyle(fontFamily: 'OtomanopeeOne'),
                onCardChanged: (_) {},
                decoration: InputDecoration(
                  labelText: theme.inputDecorationTheme.floatingLabelBehavior ==
                          FloatingLabelBehavior.always
                      ? 'Card Field'
                      : null,
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  ...ListTile.divideTiles(context: context, tiles: [
                    SwitchListTile.adaptive(
                      title: const Text('Show postal code field'),
                      value: postalCodeEnabled,
                      onChanged: (v) => setState(() => postalCodeEnabled = v),
                    ),
                    for (final theme in themes.entries)
                      Theme(
                        data: theme.value,
                        child: ColoredBox(
                          color: theme.value.scaffoldBackgroundColor,
                          child: ListTile(
                            leading: Icon(
                                theme.key == _index
                                    ? Icons.check_circle
                                    : Icons.circle,
                                color: theme.value.colorScheme.secondary),
                            title: Text(
                              theme.key,
                              style: TextStyle(
                                  color: theme.value.colorScheme.secondary),
                            ),
                            onTap: () {
                              setState(() {
                                _index = theme.key;
                              });
                            },
                          ),
                        ),
                      ),
                  ])
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<Map<String, ThemeData>>('themes', themes));
    properties
        .add(DiagnosticsProperty<bool>('postalCodeEnabled', postalCodeEnabled));
  }
}
