import 'package:flutter/services.dart';

class HttpException implements Exception {
  HttpException(this.message);
  final String message;

  @override
  String toString() => message;
}

class UpperCaseInputText extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      TextEditingValue(
        text: newValue.text.toUpperCase(),
        selection: newValue.selection,
      );
}
