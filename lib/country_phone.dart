import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneCountryInput extends StatefulWidget {
  const PhoneCountryInput({super.key});

  @override
  State<PhoneCountryInput> createState() => _PhoneCountryInputState();
}

class _PhoneCountryInputState extends State<PhoneCountryInput> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            InternationalPhoneNumberInput(
              onInputChanged: (number) {
                print(number.phoneNumber);
              },
              onInputValidated: print,
              selectorConfig: SelectorConfig(
                trailingSpace: false,
                leadingPadding: 0,
                countryComparator: (p0, p1) =>
                    p0.dialCode!.compareTo(p1.dialCode!),
              ),
              textFieldController: controller,
            ),
          ],
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<TextEditingController>('controller', controller));
  }
}
