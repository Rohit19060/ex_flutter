import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theming/app_theme.dart';
import 'theme_selection_dots.dart';

class ThemeVariantPicker extends StatelessWidget {
  const ThemeVariantPicker({
    super.key,
    required this.color,
    required this.isSelected,
    required this.selectedVariantIndex,
    this.onColorSelected,
  });
  final Color color;
  final bool isSelected;
  final int selectedVariantIndex;
  final ValueChanged<Color>? onColorSelected;

  static const double size = 32.0;
  static const double padding = 4.0;
  static const double itemSize = size + padding * 2;

  @override
  Widget build(BuildContext context) {
    final themeData = AppTheme.of(context);
    final borderColor = isSelected
        ? themeData.accentNegative
        : themeData.inactiveThemePanelRing;
    return GestureDetector(
      onTap: () => onColorSelected?.call(color),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(width: 3.0, color: borderColor),
          ),
          child: isSelected
              ? ThemeSelectionDots(selectedVariantIndex: selectedVariantIndex)
              : null,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<Color>?>.has(
        'onColorSelected', onColorSelected));
    properties.add(IntProperty('selectedVariantIndex', selectedVariantIndex));
    properties.add(DiagnosticsProperty<bool>('isSelected', isSelected));
    properties.add(ColorProperty('color', color));
  }
}
