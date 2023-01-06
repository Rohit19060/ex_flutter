import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/app_theme_settings.dart';
import 'theme_variant_picker.dart';

class ThemeSelectionList extends StatefulWidget {
  const ThemeSelectionList({
    super.key,
    required this.currentThemeSettings,
    required this.availableWidth,
    this.onColorIndexSelected,
    this.onVariantIndexSelected,
  });
  final AppThemeSettings currentThemeSettings;
  final double availableWidth;
  final ValueChanged<int>? onColorIndexSelected;
  final ValueChanged<int>? onVariantIndexSelected;

  @override
  State<ThemeSelectionList> createState() => _ThemeSelectionListState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<int>?>.has(
        'onVariantIndexSelected', onVariantIndexSelected));
    properties.add(ObjectFlagProperty<ValueChanged<int>?>.has(
        'onColorIndexSelected', onColorIndexSelected));
    properties.add(DoubleProperty('availableWidth', availableWidth));
    properties.add(DiagnosticsProperty<AppThemeSettings>(
        'currentThemeSettings', currentThemeSettings));
  }
}

class _ThemeSelectionListState extends State<ThemeSelectionList> {
  late final _controller = ScrollController(initialScrollOffset: scrollOffset);

  double get scrollOffset {
    final contentWidth = ThemeVariantPicker.itemSize * allSwatches.length;
    final selectedIndex = widget.currentThemeSettings.colorIndex;
    final offset = ThemeVariantPicker.itemSize * selectedIndex -
        (widget.availableWidth / 2 - ThemeVariantPicker.itemSize / 2);
    return max(min(offset, contentWidth - widget.availableWidth), 0);
  }

  @override
  Widget build(BuildContext context) {
    final allColors = allSwatches.map((swatch) => swatch[0]).toList();
    return ListView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      children: [
        for (final color in allColors)
          ThemeVariantPicker(
            color: color,
            isSelected: widget.currentThemeSettings.colorIndex ==
                allColors.indexOf(color),
            selectedVariantIndex: widget.currentThemeSettings.variantIndex,
            onColorSelected: (color) {
              final newIndex = allColors.indexOf(color);
              final previousIndex = widget.currentThemeSettings.colorIndex;
              if (previousIndex != newIndex) {
                widget.onColorIndexSelected?.call(allColors.indexOf(color));
              } else {
                final newVariantIndex =
                    (widget.currentThemeSettings.variantIndex + 1) % 3;
                widget.onVariantIndexSelected?.call(newVariantIndex);
              }
            },
          ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('scrollOffset', scrollOffset));
  }
}
