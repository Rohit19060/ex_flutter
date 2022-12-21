import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class ThemeSelectionDots extends StatelessWidget {
  const ThemeSelectionDots({super.key, required this.selectedVariantIndex});
  final int selectedVariantIndex;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ThemeSelectionDot(isSelected: selectedVariantIndex == 0),
          const SizedBox(width: 2.0),
          ThemeSelectionDot(isSelected: selectedVariantIndex == 1),
          const SizedBox(width: 2.0),
          ThemeSelectionDot(isSelected: selectedVariantIndex == 2),
        ],
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('selectedVariantIndex', selectedVariantIndex));
  }
}

class ThemeSelectionDot extends StatelessWidget {
  const ThemeSelectionDot({super.key, required this.isSelected});
  final bool isSelected;

  @override
  Widget build(BuildContext context) => Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? AppColors.white : AppColors.white60,
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isSelected', isSelected));
  }
}
