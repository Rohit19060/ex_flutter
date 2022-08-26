import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    super.key,
    required this.number,
  });
  final int number;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(9),
          boxShadow: [
            BoxShadow(
              offset: const Offset(4, 4),
              blurRadius: 5,
              color: Colors.black.withOpacity(0.2),
            ),
          ],
        ),
        child: Text(
          number.toString(),
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.w500, color: Colors.white),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('number', number));
  }
}
