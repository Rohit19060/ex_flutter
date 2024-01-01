import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../rotation_dialer/constant.dart';
import '../widgets/dial_number.dart';

class SimpleInput extends StatelessWidget {
  const SimpleInput({
    required this.onDigitSelected,
    super.key,
  });

  final ValueSetter<int> onDigitSelected;

  Widget _renderDialNumber(int index) => GestureDetector(
        onTap: () => onDigitSelected(index),
        child: DialNumber(number: RotaryDialConstants.inputValues[index]),
      );

  @override
  Widget build(BuildContext context) {
    const alignment = MainAxisAlignment.spaceEvenly;

    return Column(
      mainAxisAlignment: alignment,
      children: [
        for (var i = 0; i < 3; i++)
          Row(
            mainAxisAlignment: alignment,
            children: [
              for (var j = 0; j < 3; j++) _renderDialNumber(i * 3 + j),
            ],
          ),
        _renderDialNumber(9),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueSetter<int>>.has(
        'onDigitSelected', onDigitSelected));
  }
}
