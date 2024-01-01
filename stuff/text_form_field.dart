import 'package:flutter/material.dart';

class TextFormFields extends StatelessWidget {
  const TextFormFields({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Basic TextFormField',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Custom Styled TextFormField',
                  labelStyle: TextStyle(color: Colors.blue),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // TextFormField with Icon
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'TextFormField with Icon',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),

              // TextFormField with Error Text
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'TextFormField with Error',
                  border: OutlineInputBorder(),
                  errorText: 'Error! Input is invalid.',
                ),
              ),
              const SizedBox(height: 20.0),

              // TextFormField with Custom Error Style
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Custom Error Style TextFormField',
                  border: OutlineInputBorder(),
                  errorText: 'Error! Input is invalid.',
                  errorStyle: TextStyle(
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your text here',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'TextFormField with Custom Borders',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
