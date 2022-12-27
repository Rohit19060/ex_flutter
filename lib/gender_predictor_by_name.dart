import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'utilities/methods.dart';

class GenderPredictor extends StatefulWidget {
  const GenderPredictor({super.key});

  @override
  State<GenderPredictor> createState() => _GenderPredictorState();
}

class _GenderPredictorState extends State<GenderPredictor> {
  final TextEditingController _nameController = TextEditingController();

  String _result = '';
  bool _isLoading = false;
  num _probability = 0;

  Future<void> check() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please enter a name')));
      return;
    }
    _isLoading = true;
    _result = '';
    setState(() {});
    final res = await networkRequest(
        'https://api.genderize.io/?name=${_nameController.text}');
    if (res.status) {
      final x = res.data as Map<String, dynamic>;
      _isLoading = false;
      _result = x['gender'].toString();
      _probability = num.parse(x['probability'].toString()) * 100;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Enter a name to predict Gender',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _nameController,
                    onChanged: (value) => setState(() {}),
                    autofocus: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      FilteringTextInputFormatter.singleLineFormatter,
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a name',
                      labelText: 'Name',
                    ),
                    onEditingComplete: check,
                    autofillHints: const [
                      AutofillHints.name,
                      AutofillHints.givenName,
                      AutofillHints.nickname,
                    ],
                    enableInteractiveSelection: true,
                    keyboardType: TextInputType.name,
                    smartDashesType: SmartDashesType.enabled,
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                TextButton(
                  onPressed: _nameController.text.isEmpty ? null : check,
                  child: _isLoading
                      ? const CupertinoActivityIndicator()
                      : const Text('PREDICT'),
                ),
                const SizedBox(height: 50),
                if (!_isLoading && _result.isNotEmpty && _probability > 50)
                  Text(
                    _result.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 10),
                if (!_isLoading && _result.isNotEmpty)
                  if (_probability < 20)
                    const Text(
                      'Not sure! Try again',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  else if (_probability < 100)
                    const Text(
                      'Pretty sure!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  else if (_probability == 100)
                    const Text(
                      '100% sure!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                const SizedBox(height: 20),
                if (_result == 'male')
                  const Icon(Icons.man_rounded, size: 100)
                else if (_result == 'female')
                  const Icon(Icons.woman_rounded, size: 100)
              ],
            ),
          ),
        ),
      );
}
