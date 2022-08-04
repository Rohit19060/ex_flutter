import 'package:flutter/material.dart';

void main() => runApp(const AutocompleteApp());

class AutocompleteApp extends StatelessWidget {
  const AutocompleteApp({super.key});
  static const List<String> _kOptions = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Autocomplete'),
          ),
          body: Center(
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return _kOptions.where((String option) =>
                    option.contains(textEditingValue.text.toLowerCase()));
              },
              onSelected: (String selection) {
                debugPrint('You just selected $selection');
              },
            ),
          ),
        ),
      );
}

class AutocompleteDartApp extends StatelessWidget {
  const AutocompleteDartApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Autocomplete Basic User'),
          ),
          body: const Center(
            child: AutocompleteBasicUserExample(),
          ),
        ),
      );
}

@immutable
class User {
  const User({
    required this.email,
    required this.name,
  });

  final String email;
  final String name;

  @override
  String toString() => '$name, $email';

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is User && other.name == name && other.email == email;
  }

  @override
  int get hashCode => Object.hash(email, name);
}

class AutocompleteBasicUserExample extends StatelessWidget {
  const AutocompleteBasicUserExample({super.key});

  static const List<User> _userOptions = <User>[
    User(name: 'Alice', email: 'alice@example.com'),
    User(name: 'Bob', email: 'bob@example.com'),
    User(name: 'Charlie', email: 'charlie123@gmail.com'),
  ];

  static String _displayStringForOption(User option) => option.name;

  @override
  Widget build(BuildContext context) => Autocomplete<User>(
        displayStringForOption: _displayStringForOption,
        fieldViewBuilder: (BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                Function() onFieldSubmitted) =>
            TextField(
          controller: textEditingController,
          focusNode: focusNode,
          onSubmitted: (String value) {},
          decoration: const InputDecoration(
            labelText: 'User',
            border: OutlineInputBorder(),
          ),
        ),
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<User>.empty();
          }
          return _userOptions.where((User option) =>
              option.toString().contains(textEditingValue.text.toLowerCase()));
        },
        onSelected: (User selection) {
          debugPrint('You just selected ${_displayStringForOption(selection)}');
        },
      );
}
